require 'rails_helper'

RSpec.describe "public profile list" do
  context "query" do
    subject(:result) do
      MdBlogSchema.execute(query)
    end

    it "should return empty array without any post" do
      expect(result.dig("data", "publicProfileList")).to be_empty
    end

    it "should return all public profiles" do
      users = create_list(:user, 3)
      expect(result.dig("data", "publicProfileList").length).to eq(users.length)
    end
  end

  def query
    <<-gql
    query {
      publicProfileList {
        id
        username
      }
    }
    gql
  end
end
