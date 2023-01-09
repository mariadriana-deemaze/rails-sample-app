# admin user
admin = User.create!(   name: "Maria Adriana",
                        email: "mariaadriana15@gmail.com",
                        password:"123456",
                        password_confirmation:"123456",
                        admin: true,
                        activated: true,
                        activated_at: Time.zone.now )

# random non-admin users
99.times do |n|
    User.create!(   name: Faker::Name.name,
                    email: Faker::Internet.safe_email(name: "random_#{n}"),
                    password:"123456",
                    password_confirmation:"123456",
                    activated: true,
                    activated_at: Time.zone.now )
end

# attach posts to admin user
20.times do |n| 
    Micropost.create!(
        content: Faker::Quote.famous_last_words,
        user_id: admin.id )
end

# generate microposts for a subset of users
users = User.order(:create_at).take(6)
    50.times do |n| 
        users.each { |user| user.microposts.create!(content: Faker::Quote.famous_last_words)}
end

# create following relationships
users = User.all
user = users.first
following = users[2..20]
followers = users[3..30]
following.each { |followed| user.follow(followed)}
followers.each { |follower| follower.follow(user)}
