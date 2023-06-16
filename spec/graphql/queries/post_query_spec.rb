require 'rails_helper'

RSpec.describe "post" do
  context "query with no post" do
    it "should return error without any post" do
      result = MdBlogSchema.execute(query, variables: { pid: 0 })
      expect(result.dig("data")).to be_nil
      expect(result.dig("errors")).not_to be_empty
      expect(result.dig("errors").first["extensions"]["code"]).to eq("ARGUMENT_ERROR")
    end
  end

  context "query with post" do
    let!(:user) { create(:user) }
    let!(:posts) { create_list(:post, 2, user_id: user.id) }
    let!(:comments) { create_list(:comment, 2, post_id: posts.first.id, user_id: user.id) }
    subject(:result) do
      MdBlogSchema.execute(query, variables: { pid: posts.first.id })
    end

    it "should return post with comments" do
      expect(result.dig("data", "post", "title")).to eql(posts.first.title)
      expect(result.dig("data", "post", "content")).to eql(posts.first.content)
      expect(result.dig("data", "post", "username")).to eql(user.username)
      expect(result.dig("data", "commentList").length).to eq(comments.length)
      expect(result.dig("data", "commentList").first["body"]).not_to be_nil
      expect(result.dig("data", "commentList").first["username"]).to eql(user.username)
    end
  end

  def query
    <<-gql
    query post($pid: ID!) {
      post(id: $pid) {
        id
        title
        content
        username
      },
      commentList(postId: $pid) {
        postId
        body
        username
      }
  }
    gql
  end
end
