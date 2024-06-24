FactoryBot.define do
  factory :comment_on_applicant, class: "Comment" do
    association :user
    association :commentable, factory: :applicant

    comment { Faker::Lorem.sentence }
  end
end
