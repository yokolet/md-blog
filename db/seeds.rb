# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
FactoryBot.create(:user)
users = FactoryBot.create_list(:user, 3)
users.each_with_index do |user, u_idx|
  posts = FactoryBot.create_list(:post, u_idx + 1, user_id: user.id)
  posts.each_with_index do |post, p_idx|
    (0...p_idx).each do |i|
      FactoryBot.create(:comment, user_id: users[(u_idx + p_idx) % 3].id, post_id: post.id)
    end
  end
end
