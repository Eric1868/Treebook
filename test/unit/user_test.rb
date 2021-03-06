require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many :user_friendships
  should have_many :friends
  
  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end 

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:testuser).profile_name
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: "Jane", last_name: "Doe", email: "test987@domain.com")
    user.password = user.password_confirmation = "asdfasdf"
  	user.profile_name = "My Profile Name WITH Spaces"
  	
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formated correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: "Jane", last_name: "Doe", email: "test_99@domain.com")
    user.password = user.password_confirmation = "asdfasdf"

    user.profile_name = 'testuser_99'
    assert user.valid?
  end

  test "no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:testuser).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:testuser).friends << users(:testuser_3)
    users(:testuser).friends.reload
    assert users(:testuser).friends.include?(users(:testuser_3))
  end

end

