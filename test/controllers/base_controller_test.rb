require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  setup do 
    setup_google_auth_mocks
  end

  teardown do 
    delete_auth_editor
  end
  
  protected
    AUTH_TOKEN = 'token'

    def setup_google_auth_mocks
      ENV['GOOGLE_CLIENT_ID'] = 'client-id'
      @auth_editor = Editors.create('Name': 'auth', 'Email': 'auth@gmail.com')
      GoogleIDToken::Validator.any_instance.expects(:check).with(AUTH_TOKEN, 'client-id').returns({ 'email' => 'auth@gmail.com' })
    end

    def delete_auth_editor
      @auth_editor.destroy if @auth_editor
    end
end
