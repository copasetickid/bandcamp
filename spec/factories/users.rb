FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password "password"

    trait :admin do
      role :admin
    end

    trait :with_api_key do
      api_key SecureRandom.hex(16)
    end
  end
end
