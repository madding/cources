require 'rails_helper'

RSpec.describe GetNewCourseJob, type: :job do
  subject { GetNewCourseJob.new }

  describe 'test update course job' do
    let(:response) { '' }

    before do
      stub_request(:get, GetNewCourseService::DEFAULT_URL_FOR_COURCES).to_return(status: 200, body: response)
    end

    describe 'when external resourse return blank response or error' do
      before { subject.perform }

      it do
        expect(Course.count).to be_zero
      end
    end

    describe 'when external resourse wron json response' do
      let(:response) { '{sdfjksdgjlkdsj: wrong}' }

      before { subject.perform }

      it do
        expect(Course.count).to be_zero
      end
    end

    describe 'when external resourse return null fields' do
      let(:response) { '{"Valute":{"USD":{"Value":""},"EUR":{"Value":""}}}' }

      before { subject.perform }

      it do
        expect(Course.count).to be_zero
      end
    end

    describe 'when external resourse return wron fields' do
      let(:response) { '{"Valute":{"USD":{"Value":"sdfsdf"},"EUR":{"Value":-2000}}}' }

      before { subject.perform }

      it do
        expect(Course.count).to be_zero
      end
    end

    describe 'when created new course' do
      let(:response) { '{"Valute":{"USD":{"Value":32.50},"EUR":{"Value":34.80}}}' }

      before { subject.perform }

      it do
        expect(Course.count).to eql(1)

        course = Course.last
        expect(course.dollar_value).to eql(32.50)
        expect(course.euro_value).to eql(34.80)
        expect(course.manual).to eql(false)
      end
    end

    describe 'when new course exist in database' do
      let!(:course) { create(:course, dollar_value: 32.50, euro_value: 34.80) }
      let(:response) { '{"Valute":{"USD":{"Value":32.50},"EUR":{"Value":34.80}}}' }

      before { subject.perform }

      it do
        expect(Course.count).to eql(1)
        expect(course).to eql(Course.last)
      end
    end
  end
end
