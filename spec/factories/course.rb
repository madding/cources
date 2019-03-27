# frozen_string_literal: true
FactoryBot.define do
  factory :course do
    dollar_value { 32.20 }
    euro_value { 45.6 }
    expired_at { nil }
    manual { false }

    trait :manual do
      manual { true }
      expired_at { 5.second.from_now }
    end
  end
end
