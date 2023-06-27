module Oauth2ConfigHelper
  def getStateAndCodeVerifier(verifier_len=48)
    verifier_len = verifier_len < 43 ? 43 : verifier_len
    verifier_len = verifier_len > 128 ? 128 : verifier_len
    {
      state: SecureRandom.urlsafe_base64((64 * 3) / 4, false),
      code_verifier: SecureRandom.urlsafe_base64((verifier_len * 3) / 4, false)
    }
  end
end
