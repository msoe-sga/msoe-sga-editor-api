class ApplicationController < ActionController::API
  before_action :authenticate_token
  # Airrecord just raises generic ruby errors that don't inherit from StandardError so we need another rescue_from statement here.
  # Note we could just have one rescue_from statement that catches Exception but that's not good since that will catch all errors including
  # system level errors such as OutOfMemoryError
  rescue_from Airrecord::Error, with: :error_handler
  rescue_from StandardError, with: :error_handler
  attr_accessor :email

  private
    def authenticate_token
      validator = GoogleIDToken::Validator.new
      payload = validator.check(parse_bearer_token, ENV['GOOGLE_CLIENT_ID'])
      @email = payload['email']
      render json: { 'error': 'The associated Google Account does not have access to the editor', 'isAuthorized': false },
        status: 401 if Editors.find_by_email(@email).length == 0
      rescue GoogleIDToken::ValidationError
        render json: { 'error': 'Invalid Google oauth token', 'isAuthorized': false }, status: 401
    end

    def parse_bearer_token
      pattern = /^Bearer /
      header  = request.headers['Authorization'] 
      return header.gsub(pattern, '') if header && header.match(pattern)
    end

    def error_handler(error)
      render json: { error: error.message }, status: :internal_server_error
    end
end
