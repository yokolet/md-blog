class Pkce < ApplicationRecord
  validates_presence_of :state, :code_verifier
  validates_uniqueness_of :state
end
