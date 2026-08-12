class Task < ApplicationRecord
  belongs_to :user

  enum notification_type: { interval: 0, fixed_time: 1 }

  validates :name, presence: true
  validates :deadline, presence: true
  validates :notification_type, presence: true
  validates :notification_value, presence: true
  validate :notification_value_format

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
