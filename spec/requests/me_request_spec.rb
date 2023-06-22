require 'rails_helper'
include ApplicationHelper

RSpec.describe "me query request", type: :request do
  it 'returns an error code without an authenticated user' do
    post graphql_path, params: { query: query }
    json_response = JSON.parse(response.body)
    expect(json_response["errors"]).not_to be_empty
    expect(json_response["errors"].first["extensions"]["code"]).to eql('AUTHENTICATION_ERROR')
  end

  it 'returns an error code when the access token expires' do
    user = create(:user, expiry: DateTime.now - 1)
    post graphql_path,
         params: { query: query },
         headers: { "Authorization" => "Bearer #{getSignedToken(user)}" }
    json_response = JSON.parse(response.body)
    expect(json_response["errors"]).not_to be_empty
    expect(json_response["errors"].first["extensions"]["code"]).to eql('AUTHENTICATION_ERROR')
  end

  it 'returns a signed-in user info' do
    user = create(:user, expiry: DateTime.now + 1)
    post graphql_path,
         params: { query: query },
         headers: { "Authorization" => "Bearer #{getSignedToken(user)}" }
    json_response = JSON.parse(response.body)
    expect(json_response["data"]).not_to be_nil
    expect(json_response.dig("data", "me", "provider")).to eql(user.provider)
    expect(json_response.dig("data", "me", "uid")).to eql(user.uid)
    expect(json_response.dig("data", "me", "username")).to eql(user.username)
  end

  def query
    <<-gql
    query {
      me {
        id
        provider
        uid
        username
        email
        accessToken
        expiry
      }
    }
    gql
  end
end
