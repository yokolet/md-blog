module Resolvers
  class PostListResolver < GraphQL::Schema::Resolver
    type [Types::PostListType], null: false

    def resolve(**kwargs)
      Post.joins('left join users on posts.user_id = users.id')
          .joins('left join comments on comments.post_id = posts.id')
          .select('posts.id, posts.title, posts.updated_at, users.username, count(comments.*) as comment_count')
          .group(:id, 'users.username')
          .order(updated_at: :desc)
    rescue ActiveRecord::ActiveRecordError => e
      # possible pagination error handling -- will be added later
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'ARGUMENT_ERROR'})
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
