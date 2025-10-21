FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    association :movie
    association :user

    trait :anonymous do
      user { nil }
      commenter_name { Faker::Name.name }
    end
  end
end
