# frozen_string_literal: true

module Types
  class PostListType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :username, String, null: false
    field :comment_count, Integer, null: false
  end
end
