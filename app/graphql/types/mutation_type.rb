module Types
  class MutationType < Types::BaseObject
    field :post_create, mutation: Mutations::PostCreate
  end
end
