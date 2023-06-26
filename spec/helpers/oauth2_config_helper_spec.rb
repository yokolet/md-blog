require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Oauth2ConfigHelper. For example:
#
# describe Oauth2ConfigHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Oauth2ConfigHelper, type: :helper do
  subject(:attrs) do
    getStateAndCodeVerifier()
  end

  it 'returns state and code verifier' do
    expect(attrs).to have_key(:state)
    expect(attrs).to have_key(:code_verifier)
    expect(attrs[:state]).not_to be_nil
    expect(attrs[:code_verifier]).not_to be_nil
  end
end
