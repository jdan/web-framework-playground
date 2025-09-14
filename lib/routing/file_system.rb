# frozen_string_literal: true

require 'zeitwerk'
require_relative 'utils/string_utils'

##
# A file-system based router, like Next.js
#
class FileSystemRouting
  # TODO: Similar to Camping, can likely be refactored
  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['PATH_INFO']
    end

    if route
      # Call klass.get with the list of captures
      result = route[:instance].send(:call, env, *Regexp.last_match.captures)
      [200, { 'content-type' => 'text/html' }, [result]]
    else
      [404, { 'content-type' => 'text/html' }, ['404 Not Found']]
    end
  end

  class << self
    include StringUtils

    def routes
      @routes ||= []
    end

    ##
    # ::Hello => ^/hello$
    # ::Hello::X => ^/hello/(\w+)$
    def regexp_of_name(const_name)
      # namespace
      inner = const_name.split('::').map do |part|
        case part
        when 'Index' then ''
        when 'X' then '(\w+)'
        when 'N' then '(\d+)'
        else snake_of_pascal(part)
        end
      end.join('/')
      Regexp.new("^/#{inner}$")
    end

    def register_route!(cpath, value)
      return unless value.method_defined? :call

      instance = value.new
      routes << { method: 'GET',
                  pattern: regexp_of_name(cpath),
                  instance: instance }
    end

    def root(dir)
      from_dir = File.dirname(caller.first.split(':').first)
      @root = File.join(from_dir, dir)
      loader = Zeitwerk::Loader.new
      loader.on_load do |cpath, value, _abspath|
        register_route! cpath, value
      end
      loader.push_dir(@root)
      loader.setup

      loader.eager_load
    end
  end
end
