# frozen_string_literal: true

class UpdateClientCourcesJob < ApplicationJob
  queue_as :default

  def perform(course)
    ActionCable.server.broadcast('cources', course.message_data) if course.present?
  end
end
