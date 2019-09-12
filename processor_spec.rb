require_relative 'processor'

describe Processor do
  describe "process" do
    subject { described_class.new(xml, schema).process } 

    context "with xml" do
      let(:xml) do
        <<~XML
        <xml>
          <name>fernando</name>
          <age>27</age>
        </xml>
        XML
      end
      let(:schema) do
        {
          name: { css: "name", modifiers: [:capitalize] },
          age: { css: "age", modifiers: [:to_i] }
        }
      end
      let(:json) do
        {
          name: "Fernando",
          age: 27 
        }
      end

      it { is_expected.to include(json) }
    end    
  end
end