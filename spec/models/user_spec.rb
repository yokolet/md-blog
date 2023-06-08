require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:access_token) }
    it { should validate_presence_of(:expiry) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).through(:posts) }
  end
end
