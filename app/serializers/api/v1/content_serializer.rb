module Api
  module V1
    class ContentSerializer
      def self.one(content)
        {
          id: content.id,
          title: content.title,
          description: content.description,
          platform: content.platform,
          content_type: content.content_type,
          status: content.status,
          created_at: content.created_at,
          updated_at: content.updated_at,
          category: content.category ? { id: content.category.id, name: content.category.name } : nil,
          tags: content.tags.map { |tag| { id: tag.id, name: tag.name } }
        }
      end

      def self.many(contents)
        contents.map { |content| one(content) }
      end
    end
  end
end
