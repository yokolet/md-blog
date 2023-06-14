# frozen_string_literal: true

module Types
  class PublicProfileType < Types::BaseObject
    field :id, ID, null: false
    field :username, String, null: false
  end
end
