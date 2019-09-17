# text-data-extractor

The idea is to define a schema that extracts and format data from a xml file.

e.g.
```Ruby
context "with example xml" do
  subject { Process.new(xml, schema).process }

  let(:xml) do
    Nokogiri::XML(
      <<~XML
      <xml>
        <name>fernando</name>
        <age>27</age>
      </xml>
      XML
    )
  end
  let(:schema) do
    {
      name: { xpath: "name", modifiers: [:capitalize] },
      age: { xpath: "age", modifiers: [:to_i] }
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
```
