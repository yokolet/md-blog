module Resolvers
  class PostResolver < GraphQL::Schema::Resolver
    type Types::PostType, null: false

    argument :id, Int, required: true

    def resolve(id:)
      Post.joins(:user).select('posts.*, users.username').where(id: id).first
    rescue ActiveRecord::ActiveRecordError => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'ARGUMENT_ERROR'})
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
