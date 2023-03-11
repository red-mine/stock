require "test_helper"

module Stave
  class StavesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @stave = stave_staves(:one)
    end

    test "should get index" do
      get staves_url
      assert_response :success
    end

    test "should get new" do
      get new_stave_url
      assert_response :success
    end

    test "should create stave" do
      assert_difference("Stave.count") do
        post staves_url, params: { 
          stave: { 
            date: @stave.date, 
            price: @stave.price, 
            stock: @stave.stock, 
            years: @stave.years 
          } 
        }
      end

      assert_redirected_to stave_url(Stave.last)
    end

    test "should show stave" do
      get stave_url(@stave)
      assert_response :success
    end

    test "should get edit" do
      get edit_stave_url(@stave)
      assert_response :success
    end

    test "should update stave" do
      patch stave_url(@stave), params: { 
        stave: { 
          date: @stave.date, 
          price: @stave.price, 
          stock: @stave.stock,
          years: @stave.years 
        } 
      }
      assert_redirected_to stave_url(@stave)
    end

    test "should destroy stave" do
      assert_difference("Stave.count", -1) do
        delete stave_url(@stave)
      end

      assert_redirected_to staves_url
    end
  end
end
