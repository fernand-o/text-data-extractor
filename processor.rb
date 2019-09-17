require 'nokogiri'

class Processor
  def initialize(xml, schema)
    @xml = xml
    @schema = schema
    @base_path = schema[:matcher]
  end

  def process
    {
      products: [products].flatten.compact
    }
  end

  private

  attr_reader :xml, :schema, :base_path

  def products
    loop_matcher(xml.xpath(base_path), schema[:fields])
  end

  def node_value(node, props)
    return loop_matcher(node, props) if props[:matcher]

    formatted_value(node.text, props[:modifiers])
  end

  def fields_value(node, fields)
    {}.tap do |hash|
      fields.each do |field_name, props|
        inner_node = node.xpath(props[:xpath])
        hash[field_name] = node_value(inner_node, props)
      end
    end
  end

  def loop_matcher(node, props)
    matcher = props[:matcher]
    size = node.xpath(matcher).size

    size.times.map do |index|
      fields_value(node.xpath(matcher)[index], props[:fields])
    end
  end

  def formatted_value(value, modifiers)
    return value unless modifiers

    modifiers.inject(value){ |final, m| final.send(m) }
  end
end