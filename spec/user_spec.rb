require 'rails_helper'
RSpec.describe User, type: :model do
  context "Invalid user credentials" do
    it "Does not include an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("Please enter a value.")
    end
    it "Does not include a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("Please enter a value.")
    end
    it "Does not include a password confirmation" do
      user = build(:user, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("Please enter a value.")
    end
  end
  context "User credentials are not valid" do
    it "Is not a valid email (@ missing)" do
      user = build(:user, email: "testusergmail.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("Email must be written in the correct format ([name]@[mailservice].com)")
    end
    it "Is not a valid password (not enough characters)" do
      user = build(:user, password: "d381")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("Password must have a minimum of 6 characters.")
    end
    it "Password confirmation does not match password" do
      user = build(:user, password: "d381kdn2", password_confirmation: "d381kdn")
      expect(user.password_confirmation).not_to eq(user.password)
    end
  end
end
