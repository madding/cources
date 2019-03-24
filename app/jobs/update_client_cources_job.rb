# frozen_string_literal: true

class UpdateClientCourcesJob < ApplicationJob
  queue_as :default

  def perform(course)
    decorated_course = CourseDecorator.new(course).decorate
    ActionCable.server.broadcast('cources', decorated_course.message_data)
  end
end
