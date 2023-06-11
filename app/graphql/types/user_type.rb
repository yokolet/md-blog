# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :provider, Integer, null: false
    field :uid, String, null: false
    field :username, String, null: false
    field :email, String
    field :access_token, String, null: false
    field :expiry, GraphQL::Types::ISO8601DateTime, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
