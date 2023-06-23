require 'rails_helper'

RSpec.describe Pkce, type: :model do
  describe 'validations' do
    subject { build(:pkce) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:code_verifier) }
    it { should validate_uniqueness_of(:state) }
  end
end
