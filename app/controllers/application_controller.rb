class ApplicationController < ActionController::API
  before_action :authenticate_token
  attr_accessor :email

  private
    def authenticate_token
      validator = GoogleTokenValidator.new
      payload = validator.check(parse_bearer_token, ENV['GOOGLE_CLIENT_ID'])
      @email = payload['email']
      render json: { 'error': 'The associated Google Account does not have access to the editor', 'isAuthorized': false },
        status: 401 if Editors.find_by_email(@email).length == 0
      rescue GoogleIDToken::ValidationError
        render json: { 'error': 'Invalid Google oauth token', 'isAuthorized': false }, status: 401
    end

    def parse_bearer_token
      pattern = /^Bearer /
      header  = request.env['Authorization'] 
      return header.gsub(pattern, '') if header && header.match(pattern)
    end
end
