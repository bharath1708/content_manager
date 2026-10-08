class ApplicationController < ActionController::API
  include Paginatable
  include ErrorHandling
end
