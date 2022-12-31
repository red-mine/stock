require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stocks_url
    assert_response :success
  end

  test "test progress" do
    [1, 2, 3].with_progress do |i|
      Progress.note = i
      sleep 5
    end
  end
end
