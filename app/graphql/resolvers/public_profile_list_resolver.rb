module Resolvers
  class PublicProfileListResolver < GraphQL::Schema::Resolver
    type [Types::PublicProfileType], null: false

    def resolve(**kwargs)
      User.select(:id, :username)
    rescue ActiveRecord::ActiveRecordError => e
      # possible pagination error handling -- will be added later
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'ARGUMENT_ERROR'})
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
