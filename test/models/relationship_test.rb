require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup 
    @relationship = Relationship.new( follower_id: users(:adriana).id,
                                      followed_id: users(:some_other).id )
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should required a follower_id" do 
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end
end
