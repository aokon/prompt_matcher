require "rails_helper"

RSpec.describe Prompt, type: :model do
  describe "validation" do
    subject(:prompt) { described_class.new(attrs).valid? }

    context "when attributes are valid" do
      let(:attrs) { {content: "Lorem impsum"} }

      it { is_expected.to eq(true) }
    end

    context "when content is empty" do
      let(:attrs) { {content: nil} }

      it { is_expected.to eq(false) }
    end
  end
end
