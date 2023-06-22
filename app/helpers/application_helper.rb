module ApplicationHelper
  def getSignedToken(user)
    JWT.encode(
      {
        uid: user.uid,
        provider: user.provider,
        access_token: user.access_token
      },
      Rails.application.credentials.jwt_secret,
      'HS256'
    )
  end
end
