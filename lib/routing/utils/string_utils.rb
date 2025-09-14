# frozen_string_literal: true

##
# Utilities for strings
module StringUtils
  ##
  # HelloWorld -> hello_world
  def snake_of_pascal(str)
    str.gsub(/([A-Z])/) { |s| "_#{s.downcase}" }[1..]
  end
end
