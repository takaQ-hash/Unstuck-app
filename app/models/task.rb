class Task < ApplicationRecord
  belongs_to :user
    has_many :reports, dependent: :destroy

  enum :notification_type, { interval: 0, fixed_time: 1 }

  validates :name, presence: true
  validates :deadline, presence: true
  validates :notification_type, presence: true
  validates :notification_value, presence: true
  validate :notification_value_format

  before_save :reset_last_notified_at, if: :notification_settings_changed?

  def latest_report
    reports.max_by(&:created_at)
  end

  def notification_due?
    return false unless notification_type.present? && notification_value.present?

    if interval?
      interval_minutes = notification_value.to_i
      return false if interval_minutes <= 0
      return false if created_at > interval_minutes.minutes.ago

      last_notified_at.nil? || last_notified_at <= interval_minutes.minutes.ago
    elsif fixed_time?
      current_hm = Time.current.strftime("%H:%M")
      return false unless current_hm == notification_value

      last_notified_at.nil? || last_notified_at < Time.current.beginning_of_day
    end
  end

  def send_push_notification
    user.push_subscriptions.find_each do |subscription|
      ::WebPush.payload_send(
        message: { title: "Unstuck", body: "「#{name}」の報告時間です" }.to_json,
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh,
        auth: subscription.auth,
        vapid: {
          subject: "mailto:example@example.com",
          public_key: Rails.application.credentials.vapid[:public_key],
          private_key: Rails.application.credentials.vapid[:private_key]
        }
      )
    rescue ::WebPush::ExpiredSubscription
      subscription.destroy
    end
    update!(last_notified_at: Time.current)
  end

  private

  def notification_settings_changed?
    return false if new_record?

    notification_type_changed? || notification_value_changed?
  end

  def reset_last_notified_at
    self.last_notified_at = nil
  end

  def notification_value_format
    return if notification_value.blank?

    case notification_type
    when "interval"
      errors.add(:notification_value, "は数値で入力してください") unless notification_value.match?(/\A\d+\z/)
    when "fixed_time"
      errors.add(:notification_value, "はHH:MM形式で入力してください") unless notification_value.match?(/\A([01]\d|2[0-3]):[0-5]\d\z/)
    end
  end
end
