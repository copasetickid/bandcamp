FactoryGirl.define do
  factory :ticket do
    name "Make it red"
    description "Sample data man"

    factory :ticket_with_state do
      before(:create) do |instance|
        create(:state, :default)
      end
    end
  end
end
