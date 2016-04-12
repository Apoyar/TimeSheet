# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(
    handle: 'ASergey',
    password: 'password',
    first_name: 'Sergey',
    last_name: 'Andreev',
    email: 'asergey91@gmail.com',
    tel: '+32490436981',
    whatsapp: '+32490436981',
    is_admin: false
)
98.times do
    user=User.create(
        handle: Faker::Internet.user_name,
        password: Faker::Internet.password,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        tel: Faker::PhoneNumber.cell_phone,
        whatsapp: Faker::PhoneNumber.cell_phone,
        is_admin: false
    )
end
u=User.all.count
5.times do
    client=Client.create(
        name: Faker::Company.name
    )
    [*1..5].sample.times do
        project=client.projects.create(
            name: Faker::Hacker.noun
        )
        [*1..10].sample.times do
            activity=project.activities.create(
                name: Faker::Hacker.adjective
            )
            [*0..10].sample.times do
                ass=Assignment.create(
                    client_id: client.id,
                    project_id: project.id,
                    activity_id: activity.id
                )
            end
        end
    end
end
User.all.each do |user|
    [*0..10].sample.times do
        random_ass=[*1..Assignment.all.count].sample
        ass=Assignment.find(random_ass)
        if !ass.users.include? user
            ass.users << user
            [*0..10].sample.times do
                ass.tasks.create(
                    hours: 0.5*[*1..100].sample,
                    date: Date.today-[*0..5].sample,
                    notes: Faker::Lorem.paragraphs([*1..5].sample)
                )
            end
        end
    end
end
User.create(
    handle: 'HDavid',
    password: 'password',
    first_name: 'David',
    last_name: 'Hamilton',
    email: 'david@davidh.com',
    tel: '+3247781470659',
    whatsapp: '+34607482309',
    is_admin: true
)