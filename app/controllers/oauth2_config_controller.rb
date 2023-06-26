include Oauth2ConfigHelper

class Oauth2ConfigController < ApplicationController
  def twitter
    success = false
    while !success do
      attrs = getStateAndCodeVerifier()
      params = Pkce.new(**attrs)
      success = params.save
    end
    attrs[:authEndpoint] = TWITTER_OAUTH2_CONFIG[:authEndpoint]
    attrs[:redirect_uri] = TWITTER_OAUTH2_CONFIG[:redirect_uri]
    attrs[:client_id] = Rails.application.credentials.twitter.client_id
    render json: attrs
  end
end
