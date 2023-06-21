# frozen_string_literal: true

module Mutations
  class PostCreate < BaseMutation
    description "Creates a new post"

    field :post, Types::PostType, null: false

    argument :title, String, required: true
    argument :content, String, required: true

    def resolve(**post_input)
      authenticate!
      post_input[:user_id] = context[:current_user]&.id
      post = ::Post.new(**post_input)
      raise GraphQL::ExecutionError.new("Error creating post", extensions: post.errors.to_hash) unless post.save
      { post: Post.joins(:user).select('posts.*, users.username').where(id: post.id).first }
    rescue => e
      raise GraphQL::ExecutionError.new(
        e.message,
        extensions: {code: (e.respond_to?(:extensions) && e.extensions[:code]) || 'INTERNAL_SERVER_ERROR'})
    end
  end
end
