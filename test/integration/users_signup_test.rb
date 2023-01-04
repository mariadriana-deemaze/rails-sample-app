require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "Invalid signup information" do
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

  test "Valid signup" do
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
