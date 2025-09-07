# frozen_string_literal: true

require_relative 'lib/examples/basic_example'
require_relative 'lib/examples/sinatra_example'
require_relative 'lib/examples/hanami_example'
require_relative 'lib/examples/camping_example'

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
