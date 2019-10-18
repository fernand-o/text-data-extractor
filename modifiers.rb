module Modifiers
  def capitalize_and_join(values)
    values.map(&:capitalize).join(" ")
  end
end