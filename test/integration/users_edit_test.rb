require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:adriana)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)

    # navigate to edit profile path
    get edit_user_path(@user)

    # assert that correct layout gets rendered
    assert_template 'users/edit'

    # patch request w/ incorrect parameters
    patch user_path(@user), params:{ user: {  name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" }}

    # assert that the user is still on the same page after the unsuccessful request
    assert_template 'users/edit'

    # assert error message presence
    assert_select 'div.banner.banner-danger'
  end
  
  test "successful edit" do
    log_in_as(@user)

    # navigate to edit profile path
    get edit_user_path(@user)

    # assert that correct layout gets rendered
    assert_template 'users/edit'

    # save instances
    name = Faker::Name.name
    email = Faker::Internet.safe_email

    # patch request w/out password
    patch user_path(@user), params:{ user: {  name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" }}

    # assert //
    assert_not flash.empty?
    
    # assert that user gets redirected
    assert_redirected_to @user
    
    # update user obj
    @user.reload

    # assert that fields actually got updated
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    # go to edit profile page
    get edit_user_path(@user)
    
    # login the user
    log_in_as(@user)
    
    # assert that the user gets redirected
    assert_redirected_to edit_user_url(@user)
    
    # save instances
    name = Faker::Name.name
    email = Faker::Internet.safe_email

    # patch request w/out password
    patch user_path(@user), params:{ user: {  name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" }}

    assert_not flash.empty?

    # assert that user gets redirected
    assert_redirected_to @user

    # refresh the user obj
    @user.reload

    # assert that fields actually got updated
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
