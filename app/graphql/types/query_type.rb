module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :public_profile_list, [PublicProfileType], resolver: Resolvers::PublicProfileListResolver
    field :post_list, [PostListType], resolver: Resolvers::PostListResolver
    field :post, PostType, resolver: Resolvers::PostResolver do
      argument :id, ID, required: true
    end
    field :comment_list, [CommentType], resolver: Resolvers::CommentListResolver do
      argument :post_id, ID, required: true
    end
    field :me, UserType, resolver: Resolvers::MeResolver
  end
end
