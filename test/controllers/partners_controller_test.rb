require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  test "should get oauth2_prompt" do
    get :oauth2_prompt
    assert_response :success
  end

  test "should get oauth2_callback" do
    get :oauth2_callback
    assert_response :success
  end

end
