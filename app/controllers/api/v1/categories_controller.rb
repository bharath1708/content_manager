module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]

      def index
        categories, meta = paginate(Category.order(:name))
        render json: { data: CategorySerializer.many(categories), meta: meta }
      end

      def show
        render json: CategorySerializer.one(@category)
      end

      def create
        category = Category.new(category_params)
        if category.save
          render json: CategorySerializer.one(category), status: :created
        else
          render_validation_errors(category)
        end
      end

      def update
        if @category.update(category_params)
          render json: CategorySerializer.one(@category)
        else
          render_validation_errors(@category)
        end
      end

      def destroy
        if @category.destroy
          head :no_content
        else
          render_error(status: :conflict, message: "Related record is invalid or in use")
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
