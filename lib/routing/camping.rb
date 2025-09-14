# frozen_string_literal: true

require_relative 'utils/string_utils'

##
# A web server with Camping-style routing
#
# class CampingExample < CampingRouting
#   class Index
#     def get
#       ...
#     end
#   end
#
#   class X
#     def get
#       ...
#     end
#   end
# end
class CampingRouting
  class << self
    include StringUtils

    def routes
      @routes ||= []
    end

    def const_added(const_name)
      klass = const_get(const_name)
      instance = klass.new

      # TODO: Handle post/patch/delete/etc
      routes << { method: 'GET',
                  pattern: regexp_of_name(const_name),
                  instance: instance }
    end

    def regex_of_part(part)
      case part
      when 'x'
        '(\w+)'
      when 'n'
        '(\d+)'
      else
        part
      end
    end

    ##
    # :HelloWorld => ^/hello/world$
    # :HelloXWorld => ^/hello/(\w+)/world$
    def regexp_of_name(const_name)
      return %r{^/$} if const_name == :Index

      regexp_str = snake_of_pascal(const_name.to_s)
                   .split('_')
                   .map { |part| regex_of_part(part) }
                   .join('/')
      Regexp.new("^/#{regexp_str}$")
    end
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['PATH_INFO']
    end

    if route
      # Call klass.get with the list of captures
      result = route[:instance].send(:get, *Regexp.last_match.captures)
      [200, { 'content-type' => 'text/html' }, [result]]
    else
      [404, { 'content-type' => 'text/html' }, ['404 Not Found']]
    end
  end
end
