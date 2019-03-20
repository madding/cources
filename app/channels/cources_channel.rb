# frozen_string_literal: true

class CourcesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'cources'
  end
end
