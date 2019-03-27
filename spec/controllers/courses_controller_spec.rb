# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesController do
  render_views

  describe 'GET show' do
    context 'when courses not exist' do
      it do
        get :show

        expect(response).to have_http_status(200)
        expect(assigns[:current_course]).to eql(nil)
      end
    end

    context 'when exists not manual course' do
      let!(:course) { create(:course) }

      it do
        get :show

        expect(response).to have_http_status(200)
        expect(assigns[:current_course]).to eql(course)
      end
    end

    context 'when exists not manual and manual courses' do
      let!(:course) { create(:course) }
      let!(:manual_course) { create(:course, :manual, expired_at: 2.hours.from_now) }

      it do
        get :show

        expect(response).to have_http_status(200)
        expect(assigns[:current_course]).to eql(manual_course)
      end
    end

    context 'when exists not manual and manual expired courses' do
      let!(:course) { create(:course) }
      let!(:manual_course) { create(:course, :manual, expired_at: 1.hour.from_now) }

      before { Timecop.travel(2.hours.from_now) }
      after { Timecop.return }

      it do
        get :show

        expect(response).to have_http_status(200)
        expect(assigns[:current_course]).to eql(course)
      end
    end
  end
end
