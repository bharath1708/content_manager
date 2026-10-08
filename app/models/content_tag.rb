class ContentTag < ApplicationRecord
  belongs_to :content
  belongs_to :tag
  validates :tag_id, uniqueness: { scope: :content_id }
end
