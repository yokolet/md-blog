FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.question }
  end
end
