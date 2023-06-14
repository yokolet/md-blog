module Resolvers
  class PublicProfileListResolver < GraphQL::Schema::Resolver
    type [Types::PublicProfileType], null: false

    def resolve(**kwargs)
      users = User.select(:id, :username)
      if users.empty?
        return GraphQL::ExecutionError.new("Couldn't find any user", extensions: {code: 'ARGUMENT_ERROR'})
      end
      users
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
