class Content < ApplicationRecord
  enum :platform, {
    youtube: "youtube",
    instagram: "instagram",
    facebook: "facebook"
  }, validate: true

  enum :content_type, {
    video: "video",
    reel: "reel",
    post: "post"
  }, validate: true

  enum :status, {
  draft: "draft",
  published: "published",
  archived: "archived"
}, validate: true

  belongs_to :category, optional: true
  has_many :content_tags, dependent: :destroy
  has_many :tags, through: :content_tags
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :platform, presence: true
  validates :content_type, presence: true
  validates :category, presence: { message: "must exist" }, if: -> { category_id.present? }
  validate :tag_ids_must_exist
  def tag_ids=(ids)
    ids = Array(ids).compact_blank.map(&:to_i).uniq
    found = Tag.where(id: ids).pluck(:id)
    @unknown_tag_ids = ids - found
    super(found)
  end
  private

  def tag_ids_must_exist
    return if @unknown_tag_ids.blank?

    errors.add(:tag_ids, "contain unknown ids: #{@unknown_tag_ids.join(', ')}")
  end

  scope :by_platform, ->(platform) { where(platform: platform) }
  scope :by_content_type, ->(content_type) { where(content_type: content_type) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_tag, ->(tag_id) {
    where(id: ContentTag.where(tag_id: tag_id).select(:content_id))
  }

  scope :tagged_with, ->(name) {
    where(id: ContentTag.joins(:tag).where(tags: { name: name }).select(:content_id))
}
end
