require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:adriana)
  end

  test "index including pagination" do
    # log the user
    log_in_as(@user)
    
    # go to users index / all page
    get users_path

    # assert that the right template gets rendered
    assert_template "users/index"

    # check for html element for the pagination
    assert_select "div.pagination"

    User.paginate(page: 1).each do | user |
      assert_select "form[action=?]", user_path(user)
    end
  end
end
