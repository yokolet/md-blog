require 'rails_helper'

include ApplicationHelper

RSpec.describe "Oauth2s", type: :request do
  describe "GET /twitter" do
    let!(:pkce) { create(:pkce) }
    let!(:access_token) { '6LTSorOXfFcaIBTc56P2S6cyrE2ANyog8iSPm8PIPl2l9my-cSI-CH0gpSWWcPcgRAFOUB8gvW_devWElL56nw' }
    let!(:token_url) { 'https://api.twitter.com/2/oauth2/token' }
    let!(:token_headers) do
      {
        'Authorization'=>'Basic UkV3M1FuWlFlVmxCZWs4MVMwVk9kVEJCVDBZNk1UcGphUTpDTjdqSFZPTEk0aUxIMXk3N2hNUDZ6R2xTcUQtdkxrckJvQWtyd2VPZ0RJZnBKcDMwXw==',
        'Content-Type'=>'application/x-www-form-urlencoded'
      }
    end
    let!(:token_payload) do
      {
        "redirect_uri"=>"http://www.localhost:3000/oauth/twitter",
        "code"=>nil,
        "grant_type"=>"authorization_code",
        "client_id"=>Rails.application.credentials.twitter.client_id,
        "code_verifier"=>nil
      }
    end
    let!(:token_response_body) do
      {
        access_token: access_token,
        expires_in: 7200
      }
    end

    let!(:me_url) { 'https://api.twitter.com/2/users/me' }
    let!(:me_headers) do
      {
        'Content-Type'=>'application/x-www-form-urlencoded',
        'Authorization'=>"Bearer #{access_token}"
      }
    end
    let!(:me_response_body) do
      { data:
        {
          id: Faker::Number.number(digits: 16).to_s,
          username: Faker::Games::Pokemon.name
        }
      }
    end
    let!(:signed_token) do
      TestUser = Struct.new(:provider, :uid, :access_token)
      user = TestUser.new("twitter", me_response_body[:data][:id], access_token)
      getSignedToken(user)
    end

    it "returns http success" do
      stub_request(:post, token_url).
        with(
          body: token_payload,
          headers: token_headers).
        to_return(status: 200, body: token_response_body.to_json, headers: {})

      stub_request(:get, me_url).
        with(headers: me_headers).
        to_return(status: 200, body: me_response_body.to_json, headers: {})

      get "/oauth2/twitter"
      expect(response).to redirect_to(root_path(access_token: signed_token,
                                                expires_in: token_response_body[:expires_in]))
    end
  end
end
