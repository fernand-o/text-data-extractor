require 'nokogiri'

class Processor  
  def initialize(xml, schema)
    @xml = xml
    @schema = schema
    @base_path = schema[:base_path]
  end  

  def process    
    {
      products: [ hotels ].flatten.compact
    }            
  end

  private

  attr_reader :xml, :schema, :base_path

  def hotels
    return unless schema[:hotel]

    matcher = schema[:hotel][:matcher]    
    size = node(matcher).size    

    size.times.map do |i|      
      hotel node(matcher)[0]
    end    
  end

  def hotel(raw)      
    fields = schema[:hotel][:fields]    
    {}.tap do |hash|      
      fields.each do |field_name, props|
        value = raw.xpath(props[:xpath]).text        
        hash[field_name] = apply_modifiers(value, props[:modifiers])
      end    
    end    
  end

  def node(path)
    xml.xpath(base_path + path)
  end    

  def apply_modifiers(value, modifiers)
    return value unless modifiers

    modifiers.inject(value){ |final, m| final.send(m) }
  end
end