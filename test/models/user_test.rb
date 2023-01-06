require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( name: Faker::Name.name, 
                      email: Faker::Internet.safe_email, 
                      password: "password", 
                      password_confirmation: "password" )

    @empty_string = " " * 6
    @password_min_length = "a" * 5
  end

  # validates model

  test "should be valid" do 
    assert @user.valid?
  end

  # validates presence

  test "name should be present" do 
    @user.name = "    "
    assert_not @user.valid?
  end

 test "email should be present" do 
    @user.email = "    "
    assert_not @user.valid?
  end

  # validates length

  test "name should not be too long" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do 
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # validates email format

  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do | valid_address |
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do | invalid_address |
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "Foo@ExAaMplE.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # validates password format

  test "password should be present (non-blank)" do
    @user.password = @user.password_confirmation = @empty_string
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = @password_min_length
    assert_not @user.valid?
  end

  # validates uniqueness

  test "email should be unique" do 
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "authenticated? Should return false for a user with a nil digest" do
    assert_not @user.authenticated?(:remember, '') 
  end

  test "upon user deletion, the dependent posts should be destroyed" do 
    @user.save
    @user.microposts.create!( content: Faker::Quote.famous_last_words )
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
end
