require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup 
    ActionMailer::Base.deliveries.clear
    @user = users(:adriana)
  end

  test "password resets" do
    ## Forgotten password form

    # go to forgot password page 
    get new_password_reset_path

    # assert that the correct template is rendered
    assert_template "password_resets/new"

    # check if the required fields are rendered
    assert_select 'input[name=?]', 'password_reset[email]'

    # test submiting with an invalid email
    post password_resets_path, params: { password_reset: { email: '' }}

    # flash should have a warning
    assert_not flash.empty?

    # make sure we are still in the same page
    assert_template 'password_resets/new'

    # now let's test with a valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }

    # should not match - since the POST/ should have generated a new one
    assert_not_equal @user.reset_digest, @user.reload.reset_digest

    # and an email should have been sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    # flash should display a message of success
    assert_not flash.empty?

    # make sure the user get redirected
    assert_redirected_to root_url

    ## Password reset form

    user = assigns(:user)

    # try acessing the page with a wrong/invalid email
    get edit_password_reset_path(user.reset_token, email: "")
    
    # since incorrect - should redirect to the homepage
    assert_redirected_to root_url

    # experiment to access the page with an inactive user
    
    # temporarly change the user activated attribute for this test
    user.toggle!(:activated)

    # try to access page
    get edit_password_reset_path(user.reset_token, email: user.email)
    
    # should redirect to homepage
    assert_redirected_to root_url

    # change :activated property back as it was
    user.toggle!(:activated)

    # valid email and invalid token
    get edit_password_reset_path('wrong token', email: user.email)

    # should redirect to homepage
    assert_redirected_to root_url

    # valid email and valid token
    get edit_password_reset_path(user.reset_token, email: user.email)

    # correct form should now be rendered
    assert_template 'password_resets/edit'

    # check if input with the [name=email] has the correct value pre-filled
    # in this case this is hidden input we are insertint to the FE
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), params: {  email: user.email, 
                                                            user: {
                                                              password: "foobar",
                                                              password_confirmation: "nadadisso"
                                                            } }

    # assert that an error is displayed
    assert_select "div.banner.banner-danger"

    # empty password
    patch password_reset_path(user.reset_token), params: {  email: user.email, 
                                                            user: {
                                                              password: "",
                                                              password_confirmation: ""
                                                            } }
    
    # assert that an error is displayed
    assert_select "div.banner.banner-danger"

    # valid email and password
    patch password_reset_path(user.reset_token), params: {  email: user.email, 
                                                            user: {
                                                              password: "password",
                                                              password_confirmation: "password"
                                                            } }

    # user should be automatically logged in                                                        
    assert is_logged_in?

    # flash should have a warning
    assert_not flash.empty?

    # user should be redirected to their user page
    assert_redirected_to user
  end

  test "expired token" do
    # go to forgot password page 
    get new_password_reset_path

    # make a post with a valid email
    post password_resets_path, params: { password_reset: { email: @user.email }}

    # change the sent_at attribute to an expired date
    # our expiration validation is for dates under 2 hours from now
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)

    # valid email and password
    patch password_reset_path(@user.reset_token), params: {  email: @user.email, 
                                                            user: {
                                                              password: "password",
                                                              password_confirmation: "password"
                                                            } }

    # should redirect
    assert_response :redirect

    # follow redirect
    follow_redirect!

    # check the page for the expired keyword
    assert_match "expired", response.body
  end
end
