FactoryBot.define do
  factory :applicant do
    association :job

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end
end
