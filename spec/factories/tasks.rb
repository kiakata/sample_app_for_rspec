FactoryBot.define do
  factory :task do
    title { 'rspec test' }
    content { 'test content' }
    status { 0 }
  end
end
