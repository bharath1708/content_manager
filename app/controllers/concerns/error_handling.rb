module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(status: :not_found, message: e.message)
    end

    rescue_from ActionController::ParameterMissing do |e|
      render_error(status: :bad_request, message: e.message)
    end

    rescue_from ActiveRecord::InvalidForeignKey do
      render_error(status: :conflict, message: "Related record is invalid or in use")
    end
  end

  private

  def render_error(status:, message:, details: nil)
    code = Rack::Utils.status_code(status)
    body = { status: code, error: Rack::Utils::HTTP_STATUS_CODES[code], message: message }
    body[:details] = details if details.present?

    render json: body, status: status
  end

  def render_validation_errors(record)
    render_error(
      status: :unprocessable_entity,
      message: "Validation failed",
      details: record.errors.to_hash
    )
  end
end
