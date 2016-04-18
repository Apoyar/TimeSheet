# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.new(
    handle: 'ASergey',
    password: 'password',
    first_name: 'Sergey',
    last_name: 'Andreev',
    email: 'asergey91@gmail.com',
    tel: '+32490436981',
    whatsapp: '+32490436981',
    is_admin: false
).save
5.times do
    user=User.new(
        handle: Faker::Internet.user_name,
        password: Faker::Internet.password,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        tel: Faker::PhoneNumber.cell_phone,
        whatsapp: Faker::PhoneNumber.cell_phone,
        is_admin: false
    )
    user.save
end
u=User.all.count
2.times do
    client=Client.new(
        name: Faker::Company.name
    )
    client.save
    [*1..5].sample.times do
        project=client.projects.new(
            name: Faker::Hacker.noun
        )
        project.save
        [*1..5].sample.times do
            activity=project.activities.new(
                name: Faker::Hacker.adjective,
                client_id: client.id
            )
            activity.save
            [*1..5].sample.times do
                user=User.find([*1..u].sample)
                if !activity.users.include? user
                    Assignment.new(
                        activity_id: activity.id,
                        user_id: user.id
                    ).save
                end
            end
        end
    end
end
Assignment.all.each do |ass|
    [*1..50].sample.times do
        task=ass.tasks.new(
            date: Date.today-[*0..5].sample,
            hours: 0.5*[*1..100].sample,
            notes: Faker::Lorem.paragraph([*1..5].sample)
        )
        task.save
    end
end
User.new(
    handle: 'HDavid',
    password: 'password',
    first_name: 'David',
    last_name: 'Hamilton',
    email: 'david@davidh.com',
    tel: '+3247781470659',
    whatsapp: '+34607482309',
    is_admin: true
).save