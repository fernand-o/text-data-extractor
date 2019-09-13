require_relative 'processor'

describe Processor do
  describe "process" do
    subject { described_class.new(xml, schema).process }   

    context "with real xml" do
      let(:xml) do
        File.open("mgm.xml") { |f| Nokogiri::XML(f) }
      end      

      let(:schema) do
        {       
          base_path: "/XML/reservas/reserva",
          hotel: {
            matcher: "/reserva_master",
            fields: {
              origin: { xpath: "origem" },
              id: { xpath: "codigoagencia", modifiers: [:to_i] }          
            }            
          }
        }
      end
      
      let(:json) do
        {
          products: [
            {              
              origin: "RIO",
              id: 78945
            }
          ]          
        }        
      end            

      it { is_expected.to eq json }
    end
  end
end