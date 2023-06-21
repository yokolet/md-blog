# frozen_string_literal: true

module Mutations
  class CommentCreate < BaseMutation
    description "Creates a new comment"

    field :comment, Types::CommentType, null: false

    argument :post_id, ID, required: true
    argument :body, String, required: true

    def resolve(**comment_input)
      authenticate!
      comment_input[:user_id] = context[:current_user]&.id
      comment = ::Comment.new(**comment_input)
      raise GraphQL::ExecutionError.new "Error creating comment", extensions: comment.errors.to_hash unless comment.save

      { comment: Comment.joins(:user).select('comments.*, users.username').where(id: comment.id).first }
    rescue => e
      raise GraphQL::ExecutionError.new(
        e.message,
        extensions: {code: (e.respond_to?(:extensions) && e.extensions[:code]) || 'INTERNAL_SERVER_ERROR'})
    end
  end
end
