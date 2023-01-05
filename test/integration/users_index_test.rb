require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup 
    @admin = users(:adriana)
    @non_admin = users(:some_other)
  end

  test "index includes pagination and delete links" do
    # log the user
    log_in_as(@admin)
    
    # go to users index / all page
    get users_path

    # assert that the right template gets rendered
    assert_template "users/index"

    # check for html element for the pagination
    assert_select "div.pagination"

    User.paginate(page: 1).each do | user |
      # check for profile redirect button
      assert_select "form[action=?]", user_path(user)
      unless user == @admin
        #check for delete button in case the user is admin
        assert_select 'a[href=?]', user_path(user), text: "Delete"
      end
    end

    # after delerte, assert user count
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
end
