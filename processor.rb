require 'nokogiri'

class Processor
  def initialize(xml, schema)
    @xml = xml
    @schema = schema
    @base_path = schema[:base_path]
  end

  def process
    {
      products: [hotels].flatten.compact
    }
  end

  private

  attr_reader :xml, :schema, :base_path

  def hotels
    return unless schema[:hotel]

    loop_matcher(xml.xpath(base_path), schema[:hotel])
  end

  def node_value(node, props)
    return apply_modifiers(node.text, props[:modifiers]) unless props[:matcher]

    loop_matcher(node, props)
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

  def apply_modifiers(value, modifiers)
    return value unless modifiers

    modifiers.inject(value){ |final, m| final.send(m) }
  end
end