# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CourcesController do
  render_views

  describe 'GET new' do
    context 'when last manual course not exist' do
      it do
        get :new

        expect(response).to have_http_status(200)
        expect(assigns[:course].dollar_value).to eql(nil)
        expect(assigns[:course].euro_value).to eql(nil)
        expect(assigns[:course].expired_at).to eql(nil)
      end
    end

    context 'when last manual course exist' do
      let!(:last_course) { create(:course, :manual) }

      it do
        get :new

        expect(response).to have_http_status(200)
        expect(assigns[:course].dollar_value).to eql(last_course.dollar_value)
        expect(assigns[:course].euro_value).to eql(last_course.euro_value)
        expect(assigns[:course].expired_at.to_s).to eql(last_course.expired_at.to_s)
      end
    end
  end

  describe 'POST create' do
    it do
      post :create, params: { course: { euro_value: 12.5, dollar_value: 10.2, expired_at: 1.hour.from_now } }

      expect(response).to redirect_to(root_path)
      expect(Course.manual.count).to eql(1)
    end
  end
end
