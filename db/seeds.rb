User.create!( name: "Maria Adriana",
              email: "mariaadriana15@gmail.com",
              password:"123456",
              password_confirmation:"123456")


99.times do |n|
    User.create!( name: Faker::Name.name,
        email: Faker::Internet.safe_email,
        password:"123456",
        password_confirmation:"123456")
end
