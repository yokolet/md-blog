require 'rails_helper'

RSpec.describe Types::PostListType, type: :graphql do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:title).of_type('String!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:username).of_type('String!') }
  it { is_expected.to have_field(:comment_count).of_type('Int!') }
  it { is_expected.not_to have_field(:user_id) }
  it { is_expected.not_to have_field(:content) }
end
