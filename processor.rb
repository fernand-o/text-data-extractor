require 'nokogiri'

class Processor  
  def initialize(xml, schema)
    @xml = Nokogiri::XML(xml)
    @schema = schema
  end  

  def process
    {}.tap do |json|
      schema.each do |k, v|
        json[k] = find_value(v)
      end
    end
  end

  private

  attr_reader :xml, :schema

  def find_value(value)
    extract_raw_value(value).then{ |it| apply_modifiers(it, value[:modifiers]) }    
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