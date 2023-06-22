require 'rails_helper'

RSpec.describe "comment create", type: :graphql do
  context "mutation" do
    it "should raise exception without authenticated user" do
      context = {
        current_user: nil
      }
      attrs = attributes_for(:comment)
      variables = {
        "body": attrs[:body],
        "pid": 0
      }
      result = MdBlogSchema.execute(query, variables: variables, context: context)
      expect(result["errors"].first["extensions"]["code"]).to eql("AUTHENTICATION_ERROR")
    end

    it "should return created post" do
      user = create(:user)
      post = create(:post, user_id: user.id)
      context = {
        current_user: user
      }
      attrs = attributes_for(:comment)
      variables = {
        "pid": post.id,
        "body": attrs[:body]
      }
      result = MdBlogSchema.execute(query, variables: variables, context: context)
      expect(result.dig("data", "commentCreate", "comment", "id")).not_to be_nil
      expect(result.dig("data", "commentCreate", "comment", "body")).to eql(attrs[:body])
      expect(result.dig("data", "commentCreate", "comment", "username")).to eql(user.username)
    end
  end

  def query
    <<-gql
    mutation comment($pid: ID!, $body: String!) {
      commentCreate(input: {
        postId: $pid,
        body: $body
      }) {
        comment {
          id
          body
          userId
          postId
          createdAt
          updatedAt
          username
        }
      }
    }
    gql
  end
end

