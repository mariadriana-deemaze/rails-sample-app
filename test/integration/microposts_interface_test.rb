require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:some_other)
    @other_user = users(:user_1)
  end

  test "micropost interface" do 
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost:{ content: '' }}
    end
    assert_select '.banner.banner-danger'
    assert_select 'a[href=?]', '/?page=2'

    # Valid submission
    content = Faker::Quote.famous_last_words
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost:{ content: content, image: image }}
    end

    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    
    # Delete post
    assert_select 'a', text: "Delete post"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user, should  have no links
    get user_path(@other_user)
    assert_select 'a', text: "Delete post", count: 0
  end

  test "microposts sidebar count" do
    log_in_as(@user)
    get root_path
    if @user.microposts.count > 0
      assert_match "#{@user.microposts.count} posts", response.body
    end
  end
end
