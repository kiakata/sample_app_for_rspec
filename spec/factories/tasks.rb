FactoryBot.define do
  factory :task do
    association :user, factory: :user
    title { 'rspec test' }
    status { 0 }
  end
end
