module Api
  module V1
    class ContentsController < ApplicationController
      before_action :set_content, only: [ :show, :update, :destroy ]

      def index
        contents, meta = paginate(ContentQuery.new(params).call)

        render json: { data: ContentSerializer.many(contents), meta: meta }
      end

      def create
        content = Content.new(content_params)

        if content.save
          render json: ContentSerializer.one(content), status: :created
        else
          render_validation_errors(content)
        end
      end

      def show
        render json: ContentSerializer.one(@content)
      end

      def update
        if @content.update(content_params)
          render json: ContentSerializer.one(@content)
        else
          render_validation_errors(@content)
        end
      end

      def destroy
        @content.destroy
        head :no_content
      end

      private

      def set_content
        @content = Content.includes(:category, :tags).find(params[:id])
      end

      def content_params
        params.require(:content).permit(
          :title,
          :description,
          :platform,
          :content_type,
          :status,
          :category_id,
          tag_ids: []
        )
      end
    end
  end
end
