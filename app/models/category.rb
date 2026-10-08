class Category < ApplicationRecord
  has_many :contents, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
end
