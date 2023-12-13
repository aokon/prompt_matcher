# frozen_string_literal: true

RSpec.describe PromptsSearch, type: :services, es: true do
  describe "#call" do
    subject(:search) { described_class.new(phrase:, model:, page: 1) }

    let(:phrase) { "car" }
    let(:model) { Prompt }

    before do
      ["Awesome car", "Lorem ipsum", "Lorem ipsum"].each do |content|
        Prompt.create(content:)
      end
      Prompt.reindex
    end

    it "returns prompts via searchkick" do
      expect(search.call.size).to eq(1)
    end

    context "when phrase is empty" do
      let(:phrase) { nil }

      it "returns valid result" do
        expect(search.call).to eq([])
      end

      it "skips calling elastic" do
        expect(model).not_to receive(:search)

        search.call
      end
    end
  end
end
