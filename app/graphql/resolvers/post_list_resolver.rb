module Resolvers
  class PostListResolver < GraphQL::Schema::Resolver
    type [Types::PostListType], null: false

    def resolve(**kwargs)
      result = Post.joins('left join users on posts.user_id = users.id')
                   .joins('left join comments on comments.post_id = posts.id')
                   .select('posts.id, posts.title, posts.updated_at, users.username, count(comments.*) as comment_count')
                   .group(:id, 'users.username')
                   .order(updated_at: :desc)
      if result.empty?
        return GraphQL::ExecutionError.new("Couldn't find any post", extensions: {code: 'ARGUMENT_ERROR'})
      end
      result
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
