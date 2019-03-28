# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe '#self.current' do
    context 'when only not manual courses' do
      let!(:first) { create(:course, created_at: Time.now - 5.minutes) }
      let!(:current) { create(:course) }

      it do
        expect(Course.count).to eql(2)
        expect(Course.current).to eql(current)
      end
    end

    context 'when exists not expired manual course' do
      let!(:first) { create(:course, created_at: Time.now - 5.minutes) }
      let!(:last) { create(:course) }
      let!(:manual) { create(:course, :manual, created_at: Time.now - 15.minutes, expired_at: 15.minutes.from_now) }

      it do
        expect(Course.count).to eql(3)
        expect(Course.current).to eql(manual)
      end
    end

    describe 'when manual course is expired' do
      let!(:first) { create(:course, created_at: Time.now - 10.minutes) }
      let!(:last) { create(:course) }
      let!(:manual) { create(:course, :manual, created_at: Time.now - 15.minutes, expired_at: 5.minute.from_now) }

      before { Timecop.travel(10.minutes.from_now) }
      after { Timecop.return }

      it do
        expect(Course.count).to eql(3)
        expect(Course.current).to eql(last)
      end
    end

    describe 'when exist two not expired manual course' do
      let!(:first) { create(:course, created_at: 25.minutes.from_now) }
      let!(:manual1) { create(:course, :manual, created_at: Time.now - 15.minutes, expired_at: 10.minutes.from_now) }
      let!(:manual2) { create(:course, :manual, created_at: Time.now - 25.minutes, expired_at: 15.minutes.from_now) }

      it do
        expect(Course.count).to eql(3)
        expect(Course.current).to eql(manual2)
      end
    end
  end

  describe '#fill_from_last_manual' do
    let(:new_manual) { build(:course, :manual, :nullify) }

    context 'when last manual not exists' do
      before { new_manual.fill_from_last_manual }

      it do
        expect(new_manual.dollar_value).to eql(nil)
        expect(new_manual.euro_value).to eql(nil)
        expect(new_manual.expired_at).to eql(nil)
      end
    end

    context 'when last manual exists' do
      let!(:last_manual) { create(:course, :manual, expired_at: 10.minutes.from_now) }

      before do
        new_manual.fill_from_last_manual
      end

      specify do
        expect(new_manual.dollar_value).to eql(last_manual.dollar_value)
        expect(new_manual.euro_value).to eql(last_manual.euro_value)
        expect(new_manual.expired_at.to_s).to eql(last_manual.expired_at.to_s)
        expect(new_manual.created_at).to eql(nil)
      end
    end
  end
end
