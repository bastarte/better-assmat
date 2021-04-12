require "test_helper"

class UserInputsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_inputs_create_url
    assert_response :success
  end

  test "should get update" do
    get user_inputs_update_url
    assert_response :success
  end
end
