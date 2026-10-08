class Tag < ApplicationRecord
    has_many :content_tags, dependent: :destroy
    has_many :contents, through: :content_tags

    validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 30 }
end
