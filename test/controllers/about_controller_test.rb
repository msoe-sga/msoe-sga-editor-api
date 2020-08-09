require_relative './base_controller_test'

class AboutControllerTest < BaseControllerTest
  test 'index should return a page model for the about page as json' do
    # Arrange
    page = Page.new
    page.title = 'About'
    page.permalink = '/about/'
    page.contents = '# My Contents'
    page.github_ref = 'My Ref'
    page.pull_request_url = 'http://example.com/pulls/1'

    Services::PageService.any_instance.expects(:get_markdown_page)
                         .with(Rails.configuration.about_page_file_path, Rails.configuration.about_page_pr_body)
                         .returns(page)
    
    # Act
    get '/about', headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success

    assert_equal 'About', json['title']
    assert_equal '/about/', json['permalink']
    assert_equal '# My Contents', json['contents']
    assert_equal 'My Ref', json['github_ref']
    assert_equal 'http://example.com/pulls/1', json['pull_request_url']
  end

  test 'preview should return a preview for the given about page text' do
    # Arrange
    Services::KramdownService.any_instance.expects(:get_preview).with('# My Header').returns('<h1>My Header</h1>')

    # Act
    post '/about/preview', params: { text: '# My Header' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success

    assert_equal '<h1>My Header</h1>', json['result']
  end

  test 'edit should save the updated about page and return the result of the updated about page' do
    # Arrange
    page = Page.new
    page.github_ref = 'my ref'
    page.pull_request_url = 'http://example.com/pulls/1'

    Factories::PageFactory.any_instance.expects(:create_jekyll_page_text)
                          .with('My Text', Rails.configuration.about_page_title, Rails.configuration.about_permalink)
                          .returns('Formatted Page Text')
    
    Services::PageService.any_instance.expects(:save_page_update)
                         .with(Rails.configuration.about_page_file_path, Rails.configuration.about_page_title, 'Formatted Page Text', 
                               nil, Rails.configuration.about_page_pr_body)
                         .returns(page)
    
    # Act
    put '/about', params: { text: 'My Text' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success

    assert_equal 'my ref', json['github_ref']
    assert_equal 'http://example.com/pulls/1', json['pull_request_url']
  end
end
