FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :another_user, class: User do
    email { 'another_user@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
