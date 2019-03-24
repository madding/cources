# frozen_string_literal: true

class GetNewCourseJob < ApplicationJob
  queue_as :default

  def perform
    service = GetNewCourseService.new

    if service.call
      course = Course.new(dollar_value: service.dollar_value, euro_value: service.euro_value)
      logger.debug('UpdateCourseJob: Error create course: ' + course.errors.full_messages.join(', ')) unless course.save
    else
      logger.debug(service.error_message)
    end
  end
end
