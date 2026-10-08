module Api
  module V1
    class CategorySerializer
      def self.one(category)
        {
          id: category.id,
          name: category.name,
          created_at: category.created_at,
          updated_at: category.updated_at
        }
      end

      def self.many(categories)
        categories.map { |category| one(category) }
      end
    end
  end
end
