require 'nokogiri'
require 'psych'
require 'pry'

class ProcessorYml
  def initialize(xml, schema)
    @xml = xml
    @schema = schema
  end

  def process
    hash_node(schema)
  end

  private

  attr_reader :xml, :schema

  def node_value(props, base_path)
    return loop_with(props, base_path) if props["loop_with"]

    if props["path"]
      node = xml.css(base_path + " > " + props["path"])
    else
      node = xml.css(base_path).attribute(props["attr"])
    end

    formatted_value(node, props["modifiers"])
  end

  def hash_node(props, base_path = "")
    {}.tap do |hash|
      props.each do |field_name, props|
        next if field_name == "loop_with"
        hash[field_name.to_sym] = node_value(props, base_path)
      end
    end
  end

  def loop_with(props, base_path)
    path = [base_path, props["loop_with"]].reject(&:empty?).join(" > ")
    list = xml.css(path)

    list.size.times.map do |index|
      hash_node(props, "#{path}:eq(#{index + 1})")
    end
  end

  def formatted_value(node, modifiers)
    return "" unless node
    return node.text unless modifiers

    modifiers.inject(node.text){ |final, m| final.send(m) }
  end
end