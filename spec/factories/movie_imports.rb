FactoryBot.define do
  factory :movie_import do
    file_name { "MyString" }
    status { "MyString" }
    user { nil }
    processed_count { 1 }
    error_count { 1 }
  end
end
