require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:some_other)
    @micropost  = microposts(:dummy_post)
  end

  test "should redirect to create action to homepage if not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: Faker::Quote.famous_last_words }}
    end
    assert_redirected_to login_url
  end

  test "should redirect to destroy action to homepage if not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do 
    log_in_as(@user)
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end
end
