require 'test_helper'

class Admin::CourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_cources_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_cources_create_url
    assert_response :success
  end

end
