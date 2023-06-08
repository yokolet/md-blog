FactoryBot.define do
  factory :user do
    provider { 'twitter' }
    uid { Faker::Number.number(digits: 16).to_s }
    username { Faker::Games::Pokemon.name }
    access_token { Faker::Alphanumeric.alphanumeric(number: 32) }
    expiry { Faker::Time.between(from: DateTime.now + (0.5 / 24.0), to: DateTime.now + (2 / 24.0)) }
  end
end
