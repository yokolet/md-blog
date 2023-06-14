module Resolvers
  class CommentListResolver < GraphQL::Schema::Resolver
    type [Types::CommentType], null: false

    argument :post_id, Int, required: true

    def resolve(post_id:)
      Comment.joins(:user)
             .select('comments.*, users.username')
             .where(post_id: post_id)
             .order(updated_at: :asc)
    rescue ActiveRecord::ActiveRecordError => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'ARGUMENT_ERROR'})
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
