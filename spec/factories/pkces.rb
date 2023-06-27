FactoryBot.define do
  factory :pkce do
    state { SecureRandom.urlsafe_base64((64 * 3) / 4, false) }
    code_verifier { SecureRandom.urlsafe_base64((64* 3) / 4, false) }
  end
end
