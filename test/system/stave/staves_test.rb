require "application_system_test_case"

module Stave
  class StavesTest < ApplicationSystemTestCase
    setup do
      @stafe = stave_staves(:one)
    end

    test "visiting the index" do
      visit staves_url
      assert_selector "h1", text: "Staves"
    end

    test "should create stave" do
      visit staves_url
      click_on "New stave"

      fill_in "Date", with: @stafe.date
      fill_in "Price", with: @stafe.price
      fill_in "Stock", with: @stafe.stock
      fill_in "Years", with: @stafe.years
      click_on "Create Stave"

      assert_text "Stave was successfully created"
      click_on "Back"
    end

    test "should update Stave" do
      visit stafe_url(@stafe)
      click_on "Edit this stave", match: :first

      fill_in "Date", with: @stafe.date
      fill_in "Price", with: @stafe.price
      fill_in "Stock", with: @stafe.stock
      fill_in "Years", with: @stafe.years
      click_on "Update Stave"

      assert_text "Stave was successfully updated"
      click_on "Back"
    end

    test "should destroy Stave" do
      visit stafe_url(@stafe)
      click_on "Destroy this stave", match: :first

      assert_text "Stave was successfully destroyed"
    end
  end
end
