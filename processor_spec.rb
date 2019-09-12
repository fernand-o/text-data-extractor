require_relative 'processor'

describe Processor do
  describe "process" do
    subject { described_class.new(xml, schema).process } 

    context "with xml" do
      let(:xml) do
        <<~XML
        <xml>
          <nome>fernando</nome>
        </xml>
        XML
      end
      let(:schema) do
        {
          nome: { css: "nome", modifiers: [:capitalize] }
        }
      end
      let(:json) do
        {
          nome: "Fernando"          
        }
      end

      it { is_expected.to include(json) }
    end    
  end
end