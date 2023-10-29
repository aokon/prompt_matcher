require "rails_helper"

RSpec.describe "Visit home pages", type: :system, es: true do
  before do
    driven_by(:rack_test)
    Prompt.reindex
  end

  context "when search is not used" do
    it "displays valid marketing content" do
      visit root_url

      expect(page).to have_text("Discover more with our powerful search. Find what you're looking for quickly and easily.")
    end

    it "displays faked search results" do
      visit root_url

      fake_results = all(".test-fake-result")

      expect(fake_results.size).to eq(2)
    end
  end
end
