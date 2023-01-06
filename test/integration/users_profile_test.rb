require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup 
    @user = users(:adriana)    
  end

  test "profile display" do
    # go to profile page
    get user_path(@user)

    # check rendered layout
    assert_template 'users/show'

    # assert page title match
    assert_select 'title', page_full_title("#{@user.name}'s profile")

    # matching user name
    assert_select 'h5', text: @user.name

    # assert that gravatar gets rendered
    assert_select 'img.gravatar'

    # if the user has posts, check if the rendered posts count are matching
    if @user.microposts.count > 0
      assert_select 'h3>span', text: @user.microposts.count.to_s
    end

    # check for pagination render
    assert_select "div.pagination"

    # check if each post content on the first page is correctly rendered
    @user.microposts.paginate(page: 1).each do | micropost|
      assert_select "#micropost-#{micropost.id} p", text: micropost.content
    end 


  end
end
