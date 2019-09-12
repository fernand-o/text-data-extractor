require 'nokogiri'

class Processor  
  def initialize(xml, schema)
    @xml = Nokogiri::XML(xml)
    @schema = schema
  end  

  def process
    json = {}
    schema.each do |k, v|
      json[k] = final_value(v)
    end
    json
  end

  private

  attr_reader :xml, :schema

  def final_value(value)
    raw_value = extract_raw_value(value)
    apply_modifiers(raw_value, value[:modifiers])
  end

  def extract_raw_value(value)        
    return from_css(value[:css]) if value[:css]    

    "not_found"
  end

  def from_css(css)        
    xml.css(css).text
  end

  def apply_modifiers(value, modifiers)
    modifiers.inject(value){ |final, m| final.send(m) }
  end
end