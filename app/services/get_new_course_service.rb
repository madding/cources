# frozen_string_literal: true

require 'net/http'

class GetNewCourseService
  DEFAULT_URL_FOR_COURCES = URI('https://www.cbr-xml-daily.ru/daily_json.js')
  attr_reader :error_message, :dollar_value, :euro_value

  def initialize
    @error_message = nil
  end

  def call
    response = Net::HTTP.get_response(DEFAULT_URL_FOR_COURCES)

    if response.code.to_i == 200
      parsed_response = parse_response(response.body)
      if parsed_response.present?
        @dollar_value = parsed_response.dig('Valute', 'USD', 'Value')
        @euro_value = parsed_response.dig('Valute', 'EUR', 'Value')

        @error_message = "Not enough data: #{parsed_response.inspect}" if @dollar_value.nil? || @euro_value.nil?
      else
        @error_message = "JSON parsing error: #{response.body}"
      end
    else
      @error_message = "Wrong response code: #{response.code}"
    end

    success?
  end

  def success?
    @error_message.nil?
  end

  private

  def parse_response(response)
    JSON.parse(response)
  rescue
    nil
  end
end
