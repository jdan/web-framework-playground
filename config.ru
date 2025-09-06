# frozen_string_literal: true

require_relative 'src/examples/basic_example'
require_relative 'src/examples/sinatra_example'
require_relative 'src/examples/hanami_example'
require_relative 'src/examples/camping_example'

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
