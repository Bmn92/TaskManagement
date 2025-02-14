class Task < ApplicationRecord
  belongs_to :user

  validates :title, :description, :status, :due_date, presence: true

  enum status: { pending: 0, in_progress: 1, completed: 2 }
  
  validate :due_date_validation

  def due_date_validation
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "must be in the future")
    end
  end
end
