require 'nokogiri'
require 'psych'
require 'pry'
require_relative 'modifiers'

class ProcessorYml
  include Modifiers

  def initialize(xml, schema)
    @xml = xml
    @schema = schema
  end

  def process
    hash_node(schema)
  end

  private

  attr_reader :xml, :schema

  def node_raw_value(node)
    node ? node.text : ""
  end

  def tag_value(path)
    node_raw_value xml.css(path)
  end

  def attr_value(path, att)
    node_raw_value xml.css(path).attribute(att)
  end

  def node_value(props, base_path)
    return loop_with(props, base_path) if props["loop_with"]

    if props["path"]
      value = tag_value "#{base_path} > #{props["path"]}"
    else
      att = props["attr"]

      if att.is_a? Array
        value = props["attr"].map { |atr| attr_value base_path, atr }
      else
        value = attr_value base_path, att
      end
    end

    formatted_value(value, props["modifiers"])
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

  def formatted_value(value, modifiers)
    return value unless modifiers

    modifiers.inject(value) do |formatted, modifier|
      formatted.respond_to?(modifier) ? formatted.send(modifier) : send(modifier, formatted)
    end
  end
end