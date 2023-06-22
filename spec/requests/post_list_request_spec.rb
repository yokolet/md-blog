require 'rails_helper'
include ApplicationHelper

RSpec.describe "me query request", type: :request do
  let!(:users) { create_list(:user, 3) }
  let!(:posts) {
    users.each do |user|
      create(:post, user_id: user.id)
    end
  }

  it 'returns a list without an authenticated user' do
    post graphql_path, params: { query: query }
    json_response = JSON.parse(response.body)
    expect(json_response["data"]).not_to be_nil
    expect(json_response.dig("data", "postList").length).to eq(posts.length)
  end

  it 'returns a list with an authenticated user' do
    post graphql_path,
         params: { query: query },
         headers: { "Authorization" => "Bearer #{getSignedToken(users[0])}" }
    json_response = JSON.parse(response.body)
    expect(json_response["data"]).not_to be_nil
    expect(json_response.dig("data", "postList").length).to eq(posts.length)
  end

  def query
    <<-gql
    query postList {
      postList {
        id
        title
        commentCount
        username
      }
    }
    gql
  end
end
