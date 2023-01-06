require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:adriana)
    @micropost = @user.microposts.build(content: Faker::Quote.famous_last_words)
  end

  test "should be valid" do 
    assert @micropost.valid?
  end

  test "user id should be present" do 
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do 
    @micropost.content = "     "
    assert_not @micropost.valid?
  end
  
  test "user id should be at most 140 characters" do 
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be as most recent first" do 
    assert_equal microposts(:most_recent), Micropost.first
  end

end
