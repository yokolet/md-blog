module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :public_profile, resolver: Resolvers::PublicProfileResolver
    field :post_list, resolver: Resolvers::PostListResolver
    field :post, resolver: Resolvers::PostResolver
    field :comment_list, resolver: Resolvers::CommentListResolver
  end
end
