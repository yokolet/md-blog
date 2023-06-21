module Types
  class MutationType < Types::BaseObject
    field :comment_create, mutation: Mutations::CommentCreate
    field :post_create, mutation: Mutations::PostCreate
  end
end
