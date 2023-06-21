module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    private

    def current_user
      context[:current_user]
    end

    def authenticate!
      return true if current_user
      raise GraphQL::ExecutionError.new('Login required', extensions: {code: 'AUTHENTICATION_ERROR'})
    end
  end
end
