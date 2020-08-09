require_relative './base_controller_test'

class PreviewControllerTest < BaseControllerTest
  test 'preview should return a preview for the given about page text' do
    # Arrange
    Services::KramdownService.any_instance.expects(:get_preview).with('# My Header').returns('<h1>My Header</h1>')

    # Act
    post '/preview', params: { text: '# My Header' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success

    assert_equal '<h1>My Header</h1>', json['result']
  end
end
