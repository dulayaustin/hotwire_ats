FactoryBot.define do
  factory :job do
    association :account

    title { Faker::Job.title }
    status { "open" }
    job_type { Job.job_types.values.sample }
    location { Faker::Address.country }
  end
end
