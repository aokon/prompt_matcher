# frozen_string_literal: true

RSpec.describe PromptsImporter, type: :services do
  describe "#call" do
    subject(:importer) { described_class.new }

    context "when import is success" do
      let(:prompts_response) do
        File.read(Rails.root.join("spec", "fixtures", "prompts_response.json"))
      end

      before do
        stub_request(:get, /datasets-server.huggingface.co/).and_return(body: prompts_response, status: 200)
      end

      it "creates  new records" do
        expect { importer.call }.to change { Prompt.count }.by(2)
      end

      it "reindexes prompts in es" do
        expect(Prompt).to receive(:reindex).once

        importer.call
      end
    end

    context "when fetching presets reached timeout" do
      before do
        stub_request(:get, /datasets-server.huggingface.co/).and_return(status: 408)
      end

      it "raises valid error" do
        expect { importer.call }.to raise_error(PromptsImporter::PromptDownloadFailed, "Something went wrong during fetching data presents")
      end
    end

    context "when response has invalid schema" do
      let(:invalid_schema_response) do
        '{"features":[{"feature_idx":0,"name":"Prompt","type":{"dtype":"string","_type":"Value"}}],"row":[]}'
      end

      before do
        stub_request(:get, /datasets-server.huggingface.co/).and_return(body: invalid_schema_response, status: 200)
      end

      it "raises valid error" do
        expect { importer.call }.to raise_error(PromptsImporter::InvalidPresetsSchema, "Presets response has invalid schema")
      end
    end
  end
end
