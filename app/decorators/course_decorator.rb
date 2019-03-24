# frozen_string_literal: true

class CourseDecorator < Draper::Decorator
  delegate_all

  def dollar_value_with_currency
    h.number_to_currency(object.dollar_value)
  end

  def euro_value_with_currency
    h.number_to_currency(object.euro_value)
  end

  def message_data
    {
      euro_value: euro_value_with_currency,
      dollar_value: dollar_value_with_currency
    }
  end
end
