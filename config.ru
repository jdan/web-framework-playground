# frozen_string_literal: true

require_relative 'src/basic'
require_relative 'src/sinatra'
require_relative 'src/hanami'
require_relative 'src/camping'

##
# A basic Rack server
#
class Application
  def call(env)
    case ENV['ROUTING']
    when 'sinatra'
      SinatraExample.new.call(env)
    when 'hanami'
      HanamiExample.new.call(env)
    when 'camping'
      CampingExample.new.call(env)
    else
      BasicExample.new.call(env)
    end
  end
end

run Application.new
