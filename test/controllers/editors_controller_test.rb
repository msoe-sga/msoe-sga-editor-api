require 'test_helper'

class EditorsControllerTest < ActionDispatch::IntegrationTest
  test 'index should return all editors with a 200 status code from the Airtable database 
        sorted by name when the request is valid' do 
    editor1 = nil
    editor2 = nil
    editor3 = nil

    begin
      # Arrange
      editor1 = Editors.create('Name': 'test2', 'Email': 'test2@gmail.com')
      editor2 = Editors.create('Name': 'test1', 'Email': 'test1@gmail.com')
      editor3 = Editors.create('Name': 'test3', 'Email': 'test3@gmail.com')

      # Act
      get '/editors'
      json = JSON.parse(response.body)

      # Assert
      assert_response :success

      assert_equal 3, json.length
      assert_editor('test1', 'test1@gmail.com', json[0])
      assert_editor('test2', 'test2@gmail.com', json[1])
      assert_editor('test3', 'test3@gmail.com', json[2])
    ensure
      editor1.destroy if editor1
      editor2.destroy if editor2
      editor3.destroy if editor3
    end
  end

  test 'index should return an error message with a 500 status code when an Airrecord::Error is raised' do 
    # Arrange
    Editors.expects(:all).raises(Airrecord::Error, 'My Error Message')

    # Act
    get '/editors'
    json = JSON.parse(response.body)

    # Assert
    assert_response :internal_server_error
    assert_equal 'My Error Message', json['error']
  end

  test 'get_by_email should return the editor with a 200 status code when an editor 
        with the email exists in the Airtable database' do 
    editor1 = nil
    editor2 = nil
    editor3 = nil

    begin
      # Arrange
      editor1 = Editors.create('Name': 'test2', 'Email': 'test2@gmail.com')
      editor2 = Editors.create('Name': 'test1', 'Email': 'test1@gmail.com')
      editor3 = Editors.create('Name': 'test3', 'Email': 'test3@gmail.com')

      # Act
      get '/editors/email?email=test3@gmail.com'
      json = JSON.parse(response.body)

      # Assert
      assert_response :success
      assert_editor('test3', 'test3@gmail.com', json)
    ensure
      editor1.destroy if editor1
      editor2.destroy if editor2
      editor3.destroy if editor3
    end
  end

  test 'get_by_email should return an error message with a 400 status code when an editor with the email 
        does not exist in the Airtable database' do 
    # Act
    get '/editors/email?email=test3@gmail.com'
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'No editor exists with the email test3@gmail.com', json['error']
  end

  test 'get_by_email should return an error message with a 500 status code when an Airrecord::Error is raised' do 
    # Arrange
    Editors.expects(:get_by_email).raises(Airrecord::Error, 'My Error Message')

    # Act
    get '/editors/email?email=test3@gmail.com'
    json = JSON.parse(response.body)

    # Assert
    assert_response :internal_server_error
    assert_equal 'My Error Message', json['error']
  end

  test 'create should return the new editor with a 200 status code when given valid parameters' do 
  end

  test 'create should return an error message with a 500 status code when an Airrecord::Error is raised' do 
    # Arrange
    Editors.expects(:create).raises(Airrecord::Error, 'My Error Message')

    # Act
    post '/editors', params { name: 'test', email: 'test@gmail.com' }

    # Assert
    assert_response :internal_server_error
    assert_equal 'My Error Message', json['error']
  end

  test 'create should return an error message with a 400 status code when given an email of an existing edtior' do 
  end

  test 'create should return an error message with a 400 status code when not given a name' do 
  end

  test 'create should return an error message with a 400 status code when not given an email' do 
  end

  test 'edit should return the updated editor with a 200 status code when provided a new name and email' do 
  end

  test 'edit should return the updated editor with a 200 status code when provided a new name and not an email' do 
  end

  test 'edit should return the updated editor with a 200 status code when provided a new email and not a name' do 
  end

  test 'edit should return a 500 status code when an Airrecord::Error is raised' do 
    # Arrange
    Editors.expects(:find).raises(Airrecord::Error, 'My Error Message')

    # Act
    put '/editors'

    # Assert
    assert_response :internal_server_error
    assert_equal 'My Error Message', json['error']
  end

  test 'delete should return a 200 ok response when provided valid parameters' do 
  end

  test 'delete should return a 500 status code when an Airrecord::Error is raised' do 
    # Arrange
    Editors.expects(:find).raises(Airrecord::Error, 'My Error Message')

    # Act
    delete '/editors', params: { id: 'myid' }

    # Assert
    assert_response :internal_server_error
    assert_equal 'My Error Message', json['error']
  end

  private
    def assert_editor(name, email, actual)
      assert_equal name, actual['fields']['Name']
      assert_equal email, actual['fields']['Email']
    end
end
