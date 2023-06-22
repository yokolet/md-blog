require 'rails_helper'
include ApplicationHelper

RSpec.describe "me query request", type: :request do
  it 'returns an error code without an authenticated user' do
    attrs = attributes_for(:post)
    variables = {
      "title": attrs[:title],
      "content": attrs[:content]
    }
    post graphql_path, params: { query: query, variables: variables }
    json_response = JSON.parse(response.body)
    expect(json_response["errors"]).not_to be_empty
    expect(json_response["errors"].first["extensions"]["code"]).to eql('AUTHENTICATION_ERROR')
  end

  it 'creates a post with an authenticated user' do
    user = create(:user, expiry: DateTime.now + 1)
    attrs = attributes_for(:post)
    variables = {
      "title": attrs[:title],
      "content": attrs[:content]
    }
    post graphql_path,
         params: { query: query, variables: variables },
         headers: { "Authorization" => "Bearer #{getSignedToken(user)}" }
    json_response = JSON.parse(response.body)
    expect(json_response["data"]).not_to be_nil
    expect(json_response.dig("data", "postCreate", "post", "id")).not_to be_nil
    expect(json_response.dig("data", "postCreate", "post", "userId")).to eq(user.id)
    expect(json_response.dig("data", "postCreate", "post", "title")).to eql(attrs[:title])
    expect(json_response.dig("data", "postCreate", "post", "content")).to eql(attrs[:content])
    expect(json_response.dig("data", "postCreate", "post", "username")).to eql(user.username)
  end

  def query
    <<-gql
    mutation post($title: String!, $content: String!) {
      postCreate(input: {
        title: $title,
        content: $content
      }) {
        post {
          id
          title
          content
          userId
          createdAt
          updatedAt
          username
        }
      }
    }
    gql
  end
end
