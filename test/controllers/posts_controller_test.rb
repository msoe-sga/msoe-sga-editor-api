require_relative './base_controller_test'

class PostsControllerTest < BaseControllerTest
  test 'index should return all posts on master and posts in PR' do 
    # Arrange
    Services::PostService.any_instance.expects(:get_all_posts).returns([create_post_for_test('post1'), create_post_for_test('post2')])
    Services::PostService.any_instance.expects(:get_all_posts_in_pr)
                                      .with(Rails.configuration.post_pr_body)
                                      .returns([create_post_for_test('post3'), create_post_for_test('post4'), create_post_for_test('post5')])
    
    # Act
    get '/posts', headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_equal 2, json['existingPosts'].length
    assert_equal 'post1', json['existingPosts'][0]['title']
    assert_equal 'post2', json['existingPosts'][1]['title']

    assert_equal 3, json['prPosts'].length
    assert_equal 'post3', json['prPosts'][0]['title']
    assert_equal 'post4', json['prPosts'][1]['title']
    assert_equal 'post5', json['prPosts'][2]['title']
  end

  test 'create should return an error when attempting to create a post with no contents' do 
    # Act
    post '/posts', params: { author: 'Author', title: 'Title' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'Cannot create a post that is empty.', json['error']
  end

  test 'create should return an error when attempting to create a post with no author' do
    # Act
    post '/posts', params: { text: '# Header', title: 'Title' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'A author is required to create a post.', json['error']
  end

  test 'create should return an error when attempting to create a post with no title' do 
    # Act
    post '/posts', params: { text: '# Header', author: 'Author' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'A title is required to create a post.', json['error']
  end
  
  test 'create should return an error when the text provided for the post is empty' do 
    # Act
    post '/posts', params: { text: '', author: 'Author', title: 'Title' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'Cannot create a post that is empty.', json['error']
  end

  test 'create should successfully create a post when given valid parameters for a post' do 
    # Arrange
    Factories::PostFactory.any_instance.expects(:create_jekyll_post_text).with('# Header', 'Author', 'Title').returns('Formatted Text')
    Services::PostService.any_instance.expects(:create_post).with('Formatted Text', 'Title', Rails.configuration.post_pr_body).once

    # Act
    post '/posts', params: { text: '# Header', author: 'Author', title: 'Title' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success
    assert json['success']
  end

  test 'edit should return an error when attemppting to create a post with no contents' do 
    # Act
    put '/posts', params: { author: 'Author', title: 'Title', path: '_posts/post.md' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'Cannot edit a post to be empty.', json['error']
  end

  test 'edit should return an error when attempting to edit a post with no author' do 
    # Act
    put '/posts', params: { text: '# Header', title: 'Title', path: '_posts/post.md' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'A author is required to edit a post.', json['error']
  end

  test 'edit should return an error when attempting to edit a post with no title' do 
    # Act
    put '/posts', params: { text: '# Header', author: 'Author', path: '_posts/post.md' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'A title is required to edit a post.', json['error']
  end

  test 'edit should return an error when attempting to edit a post with no path' do 
    # Act
    put '/posts', params: { text: '# Header', author: 'Author', title: 'Title' }, headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'The post path is required to edit a post.', json['error']
  end
  
  test 'edit should return an error when the text provided is empty' do 
    # Act
    put '/posts', params: { text: '', author: 'Author', title: 'Title', path: '_posts/post.md' }, 
                  headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :bad_request
    assert_equal 'Cannot edit a post to be empty.', json['error']
  end

  test 'edit should successfully edit a post when not given a ref' do 
    # Arrange
    Factories::PostFactory.any_instance.expects(:create_jekyll_post_text).with('# Header', 'Author', 'Title').returns('Formatted Text')
    Services::PostService.any_instance.expects(:edit_post).with('Formatted Text', 'Title', '_posts/post.md', Rails.configuration.post_pr_body).once

    # Act
    put '/posts', params: { text: '# Header', author: 'Author', title: 'Title', path: '_posts/post.md' }, 
                  headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success
    assert json['success']
  end

  test 'edit should successfully edit a post when given a ref' do 
    # Arrange
    Factories::PostFactory.any_instance.expects(:create_jekyll_post_text).with('# Header', 'Author', 'Title').returns('Formatted Text')
    Services::PostService.any_instance.expects(:edit_post_in_pr).with('Formatted Text', 'Title', '_posts/post.md', 'ref').once

    # Act
    put '/posts', params: { text: '# Header', author: 'Author', title: 'Title', path: '_posts/post.md', ref: 'ref' }, 
                  headers: { 'Authorization': "Bearer #{AUTH_TOKEN}" }
    json = JSON.parse(response.body)

    # Assert
    assert_response :success
    assert json['success']
  end

  private

  def create_post_for_test(title)
    result = Post.new
    result.title = title
    result
  end
end
