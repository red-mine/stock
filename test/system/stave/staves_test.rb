require "application_system_test_case"

module Stave
  class StavesTest < ApplicationSystemTestCase
    setup do
      @stave = stave_staves(:one)
    end

    test "visiting the index" do
      visit staves_url
      assert_selector "h1", text: "Staves"
    end

    test "should create stave" do
      visit staves_url
      click_on "New stave"

      fill_in "Date", with: @stave.date
      fill_in "Price", with: @stave.price
      fill_in "Stock", with: @stave.stock
      fill_in "Years", with: @stave.years
      click_on "Create Stave"

      assert_text "Stave was successfully created"
      click_on "Back"
    end

    test "should update Stave" do
      visit stave_url(@stave)
      click_on "Edit this stave", match: :first

      fill_in "Date", with: @stave.date
      fill_in "Price", with: @stave.price
      fill_in "Stock", with: @stave.stock
      fill_in "Years", with: @stave.years
      click_on "Update Stave"

      assert_text "Stave was successfully updated"
      click_on "Back"
    end

    test "should destroy Stave" do
      visit stave_url(@stave)
      click_on "Destroy this stave", match: :first

      assert_text "Stave was successfully destroyed"
    end
  end
end
