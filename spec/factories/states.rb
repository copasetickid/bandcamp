FactoryGirl.define do
  factory :state do
    name "Doing"
  end

  trait :default do
    default true
  end
end
