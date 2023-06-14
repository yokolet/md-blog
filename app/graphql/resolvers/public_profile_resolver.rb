module Resolvers
  class PublicProfileResolver < GraphQL::Schema::Resolver
    type Types::PublicProfileType, null: false

    argument :id, Int, required: true

    def resolve(id:)
      user = User.select(:id, :username).where(id: id).first
      if user
        user
      else
        return GraphQL::ExecutionError.new("Couldn't find a user", extensions: {code: 'ARGUMENT_ERROR'})
      end
    rescue => e
      raise GraphQL::ExecutionError.new(e.message, extensions: {code: 'INTERNAL_SERVER_ERROR'})
    end
  end
end
