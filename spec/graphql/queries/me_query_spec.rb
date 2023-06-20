require 'rails_helper'

RSpec.describe "me query" do
  context "query" do
    it "should show user info with successful login" do
      user = create(:user)
      context = {
        current_user: user
      }
      result = MdBlogSchema.execute(query, context: context)
      expect(result.dig("data", "me", "provider")).to eql("twitter")
      expect(result.dig("data", "me", "username")).to eql(user.username)
    end

    it "should return authentication error without successful login" do
      context = {
        current_user: nil
      }
      result = MdBlogSchema.execute(query, context: context)
      expect(result["errors"]).not_to be_empty
      expect(result["errors"].first["extensions"]["code"]).to eql("AUTHENTICATION_ERROR")
    end
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
