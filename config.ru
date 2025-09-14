# frozen_string_literal: true

require_relative 'examples/basic_example'
require_relative 'examples/sinatra_example'
require_relative 'examples/hanami_example'
require_relative 'examples/camping_example'
require_relative 'examples/file_system_example'

##
# A basic Rack server
#
class Application
  def call(env)
    case ENV.fetch('ROUTING', nil)
    when 'sinatra' then SinatraExample.new.call(env)
    when 'hanami' then HanamiExample.new.call(env)
    when 'camping' then CampingExample.new.call(env)
    when 'basic' then BasicExample.new.call(env)
    when 'file_system' then FileSystemExample.new.call(env)
    else raise NotImplementedError
    end
  end
end

run Application.new
