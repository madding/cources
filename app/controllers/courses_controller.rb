# frozen_string_literal: true

class CoursesController < ApplicationController
  def show
    @current_course = Course.current
  end
end
