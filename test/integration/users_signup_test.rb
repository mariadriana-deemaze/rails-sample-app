require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup 
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    # go to signup page
    get signup_path

    # post to user#new path w/ invalid params
    # and assert user count is unchanged
    assert_no_difference 'User.count' do
      post users_path, params: { user: {  name:"",
                                          email:"user@invalid",
                                          password:"foo",
                                          password_confirmation:"bar" } }
    end

    # assert matching rendered template
    assert_template 'users/new'

    # assert error message presence
    assert_select 'div.banner.banner-danger'
  end

  test "valid signup information with account activation" do
    # go to signup page
    get signup_path

    # post to user#new path w/ valid params
    # and assert user count is changed by one increment
    assert_difference "User.count", 1 do
      post users_path, params: { user: {  name: Faker::Name.name,
                                          email: Faker::Internet.safe_email,
                                          password: "foobar",
                                          password_confirmation:"foobar" } }
    end
    
    # check if activation email was sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    # check if created user is cannot login due to account not being activated
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    #get edit_account_activation_path("invalid token", email: user.email)
    #assert_not is_logged_in?

    # valid token and invalid email
    #get edit_account_activation_path(user.activation_token, email: 'wrong')
    #assert_not is_logged_in?

    # valid token and valid email
    # and assert if user account attribute is correctly truthy
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    
    # test follows to next page
    follow_redirect!

    # assert matching rendered template
    assert_template "users/show"

    # assert matching rendered template
    assert flash[:success]

    # use test_helper defined method to assert is user is logged in
    assert is_logged_in?
  end
end
