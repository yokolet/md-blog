require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(1).is_at_most(300) }
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
