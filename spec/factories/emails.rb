FactoryBot.define do
  factory :email do
    association :applicant
    association :user

    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
