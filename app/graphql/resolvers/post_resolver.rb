module Resolvers
  class PostResolver < GraphQL::Schema::Resolver
    type Types::PostType, null: false

    argument :id, Int, required: true

    def resolve(id:)
      post = Post.joins(:user).select('posts.*, users.username').where(id: id).first
      if post
        post
      else
        return GraphQL::ExecutionError.new("Couldn't find a post id = #{id}", extensions: {code: 'ARGUMENT_ERROR'})
      end
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
