require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:adriana)
  end

  test "Login with valid information followed by a logout" do
    # go to login page
    get login_path

    # post to login#create path w/ valid params
    post login_path, params: { session: { email:     @user.email, 
                                          password: 'password' }}

    # assert with the test_helper defined method if there's a user session
    assert is_logged_in?

    # assert correct redirect
    assert_redirected_to @user
    
    # test follows to next page
    follow_redirect!

    # assert matching rendered template
    assert_template 'users/show'

    # assert that there are no links redirecting to the login page
    assert_select "a[href=?]", login_path, count: 0

    # assert that exists links to the logout page
    assert_select "a[href=?]", logout_path

    # assert that exists links to the user profile page
    assert_select "a[href=?]", user_path(@user)

    # destroy session
    delete logout_path

    # assert with the test_helper defined method if there's no session
    assert_not is_logged_in?  
    
    # assert if there was a redirect after the session destroy
    assert_redirected_to root_url

    # test follows the redirect
    follow_redirect!

    # assert that there are rendered links redirecting to the login page
    assert_select "form[action=?]", login_path

    # assert that no links for the logout page are rendered
    assert_select "a[href=?]", logout_path, count: 0
 
    # assert that no links for the user profile page are rendered
    assert_select "a[href=?]", user_path(@user), count: 0
  end


  test "Login with valid email and invalid password" do
    # go to login page
    get login_path

    # assert matching rendered template
    assert_template 'sessions/new'

    # post to login#create path w/ valid params
    post login_path, params: { session: { email:     @user.email, 
                                          password: 'invalid' }}

    # assert with the test_helper defined method if there's no session
    assert_not is_logged_in?

    # assert matching rendered template
    assert_template 'sessions/new'

    # assert flash.now presence
    assert_not flash.empty?

    # assert that flash message is gone
    get root_path
    assert flash.empty?
  end
end
