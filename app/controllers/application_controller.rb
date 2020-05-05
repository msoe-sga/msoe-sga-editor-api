class ApplicationController < ActionController::API
  before_action :authenticate_token
  attr_accessor :email

  private
    def authenticate_token
      validator = GoogleIDToken::Validator.new
      payload = validator.check(parse_bearer_token, ENV['GOOGLE_CLIENT_ID'])
      email = payload['email']
      rescue GoogleIDToken::ValidationError => e
        render json: { 'error': 'Invalid Google oauth token' }, status: 401
    end

    def parse_bearer_token
      pattern = /^Bearer /
      header  = request.env['Authorization'] 
      header.gsub(pattern, '') if header && header.match(pattern)
    end
end
