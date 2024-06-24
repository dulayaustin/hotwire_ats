FactoryBot.define do
  factory :notification do
    association :user

    params { {"email" => FactoryBot.create(:applicant).as_json, "applicant" => FactoryBot.create(:email).as_json } }
  end
end
