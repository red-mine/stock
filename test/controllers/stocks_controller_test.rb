require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stocks_url
    assert_response :success
  end
end
