require "test_helper"

module Stave
  class StavesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @stafe = stave_staves(:one)
    end

    test "should get index" do
      get staves_url
      assert_response :success
    end

    test "should get new" do
      get new_stafe_url
      assert_response :success
    end

    test "should create stafe" do
      assert_difference("Stave.count") do
        post staves_url, params: { stafe: { date: @stafe.date, price: @stafe.price, stock: @stafe.stock } }
      end

      assert_redirected_to stafe_url(Stave.last)
    end

    test "should show stafe" do
      get stafe_url(@stafe)
      assert_response :success
    end

    test "should get edit" do
      get edit_stafe_url(@stafe)
      assert_response :success
    end

    test "should update stafe" do
      patch stafe_url(@stafe), params: { stafe: { date: @stafe.date, price: @stafe.price, stock: @stafe.stock } }
      assert_redirected_to stafe_url(@stafe)
    end

    test "should destroy stafe" do
      assert_difference("Stave.count", -1) do
        delete stafe_url(@stafe)
      end

      assert_redirected_to staves_url
    end
  end
end
