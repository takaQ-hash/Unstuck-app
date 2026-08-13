class Report < ApplicationRecord
  belongs_to :task

  enum status: { in_progress: 0, struggling: 1 }

  validates :status, presence: true
end
