require 'rails_helper'

RSpec.describe "post list", type: :graphql do
  context "query with no post" do
    it "should return empty array without any post" do
      result = MdBlogSchema.execute(query)
      expect(result.dig("data", "postList")).to be_empty
    end
  end

  context "query with post" do
    let!(:users) { create_list(:user, 3) }
    subject(:result) do
      MdBlogSchema.execute(query)
    end

    it "should return all posts" do
      posts = users.each do |user|
        create(:post, user_id: user.id)
      end
      expect(result.dig("data", "postList").length).to eq(posts.length)
      expect(result.dig("data", "postList").first["title"]).not_to be_nil
      expect(result.dig("data", "postList").first["updatedAt"]).not_to be_nil
      expect(result.dig("data", "postList").first["commentCount"]).to eq(0)
      expect(result.dig("data", "postList").first["username"]).not_to be_nil
    end
  end

  def query
    <<-gql
    query postLlist {
      postList {
        id
        title
        updatedAt
        commentCount
        username
      }
    }
    gql
  end
end
