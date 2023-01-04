require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup 
    @user       = users(:adriana)
    @other_user = users(:some_other)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit if not logged in" do 
    # go to edit user / profile page
    get edit_user_path(@user)

    # verify if the flash is not empty
    assert_not flash.empty?

    # assert that there was a redirect to the login page
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    # try to update user data
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }} 
    
    # verify if the flash is not empty
    assert_not flash.empty?

    # assert that there was a redirect to the login page
    assert_redirected_to login_url
  end

  test "should redirect from edit page when logged in as wrong user" do 
    # login as one account
    log_in_as(@other_user)

    # GET/ edit / profile page with a different user
    get edit_user_path(@user)

    assert flash.empty?
    
    # assert that user gets redirected
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do 
    # login as one account
    log_in_as(@other_user)

    # try to update user data
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }} 

    assert flash.empty?
    
    # assert that user gets redirected
    assert_redirected_to root_url
  end

  test "should redirect to index when not logged in" do
    # go to the users path
    get users_path
    
    # assert that user is correctly re-directed
    assert_redirected_to login_url
  end
end
