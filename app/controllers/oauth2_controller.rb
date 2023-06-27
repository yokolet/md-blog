class Oauth2Controller < ApplicationController
  include ApplicationHelper

  # This controller should receive state and code as URL parameters from OAuth2 endpoint.
  # The controller is a redirect URI to the auth endpoint, so no client hits this.
  def twitter
    basicAuthToken = getBasicAuthToken(
      Rails.application.credentials.twitter.client_id,
      Rails.application.credentials.twitter.client_secret
    )
    oauthTokenParams = getOauthTokenParams(
      params,
      TWITTER_OAUTH2_CONFIG,
      Rails.application.credentials.twitter.client_id
    )
    access_token, expires_in = getOauthToken(
      "https://api.twitter.com",
      "/2/oauth2/token",
      basicAuthToken,
      oauthTokenParams
    )
    expiry = DateTime.now + expires_in.to_i.seconds
    data = getUser("https://api.twitter.com", "/2/users/me", access_token)
    user = getUserFromDb(
      {
        provider: User.providers[:twitter],
        uid: data['id'],
        username: data['username'],
        access_token: access_token,
        expiry: expiry
      }
    )
    signedToken = getSignedToken(user)
    redirect_to(root_path(access_token: signedToken, expires_in: expires_in))
  ensure
    removeCodeVerifier(params)
  end

  private

  def getBasicAuthToken(client_id, client_secret)
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def getOauthTokenParams(params, oauth2_configs, client_id)
    {
      redirect_uri: oauth2_configs[:redirect_uri],
      code: params[:code],
      grant_type: 'authorization_code',
      client_id: client_id,
      code_verifier: Pkce.where(state: params[:state]).first&.code_verifier
    }
  end

  def getOauthToken(url, path, basicAuthToken, oauthTokenParams)
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{basicAuthToken}"
      }
    )
    response = conn.post(path, URI.encode_www_form(oauthTokenParams))
    body_obj = JSON.parse(response.body)
    [body_obj['access_token'], body_obj['expires_in']]
  end

  def removeCodeVerifier(params)
    Pkce.where(state: params[:state]).first&.destroy
  end

  def getUser(url, path, access_token)
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Bearer #{access_token}"
      }
    )
    response = conn.get(path)
    body_obj = JSON.parse(response.body)
    body_obj['data']
  end

  def getUserFromDb(user)
    User.find_or_create_by(user)
  end
end
