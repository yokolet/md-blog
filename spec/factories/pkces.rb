FactoryBot.define do
  factory :pkce do
    state { SecureRandom.base64(64) }
    code_verifier { SecureRandom.base64(32) }
  end
end
