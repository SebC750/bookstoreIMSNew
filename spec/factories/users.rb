FactoryBot.define do
  factory :user do
    email { "testuser@gmail.com" }
    password { "testpassword" }
    password_confirmation { "testpassword" }
  end
end
