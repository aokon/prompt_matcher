# frozen_string_literal: true

RSpec.describe PromptsSearch, type: :services, es: true do
  describe "#call" do
    subject(:search) { described_class.new(phrase:) }

    let(:phrase) { "car" }

    before do
      ["Awesome car", "Lorem ipsum", "Lorem ipsum"].each do |content|
        Prompt.create(content:)
      end
      Prompt.reindex
    end

    it "returns prompts via searchkick" do
      expect(search.call.size).to eq(1)
    end
  end
end
