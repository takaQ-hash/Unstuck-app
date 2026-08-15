class Task < ApplicationRecord
  belongs_to :user
    has_many :reports, dependent: :destroy

  enum :notification_type, { interval: 0, fixed_time: 1 }

  validates :name, presence: true
  validates :deadline, presence: true
  validates :notification_type, presence: true
  validates :notification_value, presence: true
  validate :notification_value_format

  def latest_report
    reports.max_by(&:created_at)
  end

  def notification_due?
    return false unless notification_type.present? && notification_value.present?

    if interval?
      minutes = notification_value.to_i
      return false if minutes <= 0

      elapsed_minutes = ((Time.current - created_at) / 60).to_i
      elapsed_minutes.positive? && elapsed_minutes % minutes == 0
    elsif fixed_time?
      current_hm = Time.current.strftime("%H:%M")
      current_hm == notification_value
    end
  end

  private

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
