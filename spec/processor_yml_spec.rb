require_relative '../processor_yml'
require 'pry'

describe ProcessorYml do
  describe "process" do
    subject { described_class.new(xml, schema).process }

    context "here we go" do
      let(:xml) do
        File.open("spec/orinter.xml") { |f| Nokogiri::XML(f) }
      end

      let(:schema) do
        Psych.load(
          <<~YAML
            sales:
              loop_with: reservaList > reserva
              document:
                path: id
              date:
                path: dummy
              products:
                loop_with: reservaServicoList > reservaServicoList
                document:
                  path: id
                kind:
                  path: servico > servicoTipo
                description:
                  path: servico > nmServico
                passengers:
                  loop_with: servico > reservaNomeList > reservaNome
                  name:
                    attr: nmNome
          YAML
        )
      end

      let(:json) do
        {
          sales: [
            {
              document: "164270",
              date: "",
              products: [
                {
                  description: "Passeio a  Cânion Itaimbézinho - REGULAR",
                  document: "1161114",
                  kind: "PASSEIO",
                  passengers: [
                    {
                      name: "JACK"
                    },
                    {
                      name: "KATE"
                    }
                  ]
                },
                {
                  description: "Passeio Gran Reservas - REGULAR",
                  document: "1161115",
                  kind: "PASSEIO",
                  passengers: [
                    {
                      name: "HUGO"
                    },
                    {
                      name: "SAYID"
                    }
                  ]
                },
                {
                  description: "Traslado Aeroporto de Porto Alegre / Hotel Gramado OU Canela / Aeroporto de Porto Alegre + Passeios - REGULAR",
                  document: "1162380",
                  kind: "PACOTE_SERVICOS",
                  passengers: [
                    {
                      name: "JOHN"
                    },
                    {
                      name: "JAMES"
                    }
                  ]
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