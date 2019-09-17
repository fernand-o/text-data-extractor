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
          matcher: "/XML/reservas/reserva",
          fields: {
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
          matcher: "/ConsultaPedidosPeriodoV2Response/ConsultaPedidosPeriodoV2Result/Pedidos",
          fields: {
            matcher: "Pedido",
            fields: {
              kind: { xpath: "TipoDoProduto"},
              document: { xpath: "CodVoucher" },
              status: { xpath: "Status" },
              passengers: {
                xpath: "Passageiros",
                matcher: "Passageiro",
                fields: {
                  name: { xpath: "Nome", modifiers: [:capitalize]},
                  age: { xpath: "Idade", modifiers: [:to_i]},
                  value: { xpath: "Valor/Moeda/Liquido", modifiers: [:to_f] },
                  tax: { xpath: "Valor/Moeda/Taxas", modifiers: [:to_f] }
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
              kind: "SEG" ,
              document: "987654",
              status: "Processado",
              passengers: [
                {
                  name: "Harvey spector",
                  age: 74,
                  value: 27.89,
                  tax: 0.11
                },
                {
                  name: "Michael ross",
                  age: 72,
                  value: 39.85,
                  tax: 0.15
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