FactoryBot.define do
  factory :user do
    email { 'test@rspec.test' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :another_user, class: User do
    email { 'another_user@rspec.test' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
