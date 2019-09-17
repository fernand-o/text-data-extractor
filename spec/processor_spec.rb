require_relative '../processor'

describe Processor do
  describe "process" do
    subject { described_class.new(xml, schema).process }

    context "mgm" do
      let(:xml) do
        File.open("spec/mgm.xml") { |f| Nokogiri::XML(f) }
      end

      let(:schema) do
        {
          base_path: "/XML/reservas/reserva",
          hotel: {
            matcher: "reserva_master",
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

    context "tour" do
      let(:xml) do
        File.open("spec/tour.xml") { |f| Nokogiri::XML(f) }
      end

      let(:schema) do
        {
          base_path: "/ConsultaPedidosPeriodoV2Response/ConsultaPedidosPeriodoV2Result/Pedidos",
          hotel: {
            matcher: "Pedido",
            fields: {
              loc: { xpath: "CodVoucher" },
              status: { xpath: "Status" },
              passengers: {
                xpath: "Passageiros",
                matcher: "Passageiro",
                fields: {
                  name: { xpath: "Nome", modifiers: [:capitalize]},
                  age: { xpath: "Idade", modifiers: [:to_i]}
                }
              }
            }
          }
        }
      end

      let(:json) do
        {
          products: [
            {
              loc: "987654",
              status: "Processado",
              passengers: [
                {
                  name: "Harvey spector",
                  age: 74
                },
                {
                  name: "Michael ross",
                  age: 72
                }
              ]
            }
          ]
        }
      end

      it { is_expected.to eq json }
    end
  end
end