# frozen_string_literal: true

class GetNewCourseJob < ApplicationJob
  queue_as :default

  def perform
    service = GetNewCourseService.new

    if service.call
      last_course = Course.not_manual.last
      # skip equals course
      return if last_course.present? &&
                (last_course.dollar_value - service.dollar_value.to_f).abs < 0.01 &&
                (last_course.euro_value - service.euro_value.to_f).abs < 0.01

      course = Course.new(dollar_value: service.dollar_value, euro_value: service.euro_value)
      logger.debug('UpdateCourseJob: Error create course: ' + course.errors.full_messages.join(', ')) unless course.save
    else
      logger.debug(service.error_message)
    end
  end
end
