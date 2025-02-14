class User < ApplicationRecord
  has_secure_password # Provides password encryption methods

  validates_presence_of :name, :phone, :status
  validates :email, presence: true, uniqueness: true

  enum status: { active: 0, inactive: 1 }

  has_many :tasks, dependent: :destroy # User has many tasks
end
