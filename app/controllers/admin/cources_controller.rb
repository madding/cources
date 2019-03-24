# frozen_string_literal: true

class Admin::CourcesController < ApplicationController
  def new
    @course = Course.new.fill_from_last_manual
  end

  def create
    @course = Course.new(permitted_params.merge(manual: true))

    if @course.save
      flash[:success] = 'Course was successfully updated'
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  private

  def permitted_params
    params.require(:course).permit(:euro_value, :dollar_value, :expired_at)
  end
end
