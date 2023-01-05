require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
    def setup 
        @user = users(:adriana)
        remember(@user)
        # log_in_as(@user)
    end
    
    # TODO: Check why the current_user is nil in this test scenario
    # test "current_user returns right user when session is nil" do 
    #    assert_equal @user, current_user
    #    assert is_logged_in?
    # end
    
    test "current_user returns nil when remember digest is wrong" do 
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
    end
end
