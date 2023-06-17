module Resolvers
  class MeResolver < GraphQL::Schema::Resolver
    type Types::UserType, null: false

    def resolve(**kwargs)
      user = context[:current_user]
      if user
        user
      else
        return GraphQL::ExecutionError.new('Login required', extensions: {code: 'AUTHENTICATION_ERROR'})
      end
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
