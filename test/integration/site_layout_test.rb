require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

    def setup 
    @user = users(:adriana)
    end

    test "layout links" do
      get root_path
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path
      assert_select "a[href=?]", help_path 
      assert_select "a[href=?]", about_path 
      assert_select "a[href=?]", contact_path
    end

    test "homepage should render static content" do
      # go to homepage
      get root_path

      # check rendered layout
      assert_template 'static_pages/home'

      assert_select 'h1', text: 'Welcome to the sample app'
    end

    test "homepage should render user info" do
      # login as user
      log_in_as(@user)
      
      # go to homepage
      get root_path

      # check rendered layout
      assert_template 'static_pages/home'

      # check if username is correctly rendered
      assert_select 'aside a', text: @user.name

      # check if emails is correctly rendered
      assert_select 'aside span', text: @user.email

      # check if post amount if correctly rendered
      assert_select 'aside span', text: "#{@user.microposts.count} posts"
    end

end
