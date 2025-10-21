FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    synopsis { Faker::Lorem.paragraph(sentence_count: 5) }
    year { rand(1950..Date.current.year) }
    duration { rand(80..180) }
    director { Faker::Name.name }
    association :user

    trait :with_categories do
      after(:create) do |movie|
        movie.categories << create_list(:category, 2)
      end
    end

    trait :with_tags do
      after(:create) do |movie|
        movie.tags << create_list(:tag, 3)
      end
    end
  end
end
