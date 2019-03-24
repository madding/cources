# frozen_string_literal: true

class Course < ApplicationRecord
  attr_accessor :skip_expired_at_validation
  scope :manual, -> { where(manual: true) }
  scope :not_manual, -> { where(manual: false) }
  scope :not_expired, -> { where('expired_at > ?', Time.now) }

  validates :euro_value, :dollar_value, presence: true, numericality: { greater_than: 0.0 }
  validates :expired_at, presence: true, if: :manual?

  validate :validate_expired_at_after_now, on: :create, if: ->(c) { !c.skip_expired_at_validation && c.manual? }

  after_create :update_information_on_clients

  def self.current
    manual.not_expired.order(:expired_at).last || not_manual.order(:created_at).last
  end

  def fill_from_last_manual
    if last_manual = Course.manual.last
      assign_attributes(
        dollar_value: last_manual.dollar_value,
        euro_value: last_manual.euro_value,
        expired_at: last_manual.expired_at
      )
    end
    self
  end

  def validate_expired_at_after_now
    errors.add(:expired_at, 'expired_at must be in future') if expired_at < Time.now
  end

  private

  def update_information_on_clients
    UpdateClientCourcesJob.perform_now(Course.current)
  end
end
