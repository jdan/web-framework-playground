# frozen_string_literal: true

require_relative 'src/routing/basic'
require_relative 'src/routing/sinatra'
require_relative 'src/routing/hanami'
require_relative 'src/routing/camping'

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
