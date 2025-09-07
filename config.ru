# frozen_string_literal: true

require_relative 'examples/basic_example'
require_relative 'examples/sinatra_example'
require_relative 'examples/hanami_example'
require_relative 'examples/camping_example'

##
# A basic Rack server
#
class Application
  def call(env)
    case ENV.fetch('ROUTING', nil)
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
