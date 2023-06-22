require 'rails_helper'

RSpec.describe Types::PublicProfileType, type: :graphql do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:username).of_type('String!') }
  it { is_expected.not_to have_field(:provider) }
  it { is_expected.not_to have_field(:uid) }
  it { is_expected.not_to have_field(:email) }
  it { is_expected.not_to have_field(:access_token) }
  it { is_expected.not_to have_field(:expiry) }
end
