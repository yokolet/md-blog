require 'rails_helper'

RSpec.describe "Oauth2Configs", type: :request do
  describe "GET /twitter" do
    it "returns http success" do
      get "/oauth2_config/twitter"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('authEndpoint')
      expect(json_response).to have_key('redirect_uri')
      expect(json_response).to have_key('state')
      expect(json_response).to have_key('code_verifier')
      expect(json_response).to have_key('client_id')
    end
  end
end
