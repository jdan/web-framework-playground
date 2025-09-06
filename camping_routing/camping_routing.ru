# frozen_string_literal: true

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
    def routes
      @routes ||= []
    end

    def const_added(const_name)
      klass = const_get(const_name)
      instance = klass.new

      # TODO: Handle post/patch/delete/etc
      routes << if const_name == :Index
                  { method: 'GET',
                    pattern: %r{^/$},
                    instance: instance }
                else
                  # HelloWorld => hello world
                  parts = const_name.to_s.gsub(/([A-Z])/) { |s| " #{s.downcase}" }.split(' ')

                  # hello world => ^/hello/world$
                  # hello x world => ^/hello/(\w+)/world$
                  re = Regexp.new("^/#{parts.map do |part|
                    if part == 'x'
                      '(\w+)'
                    elsif part == 'n'
                      '(\d+)'
                    else
                      part
                    end
                  end.join('/')}$")

                  { method: 'GET',
                    pattern: re,
                    instance: instance }
                end
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

class CampingExample < CampingRouting
  # /
  class Index
    def get
      <<~HTML.chomp
        You got here by: /
      HTML
    end
  end

  # /welcome/to/my/site
  class WelcomeToMySite
    def get
      <<~HTML.chomp
        You got here by: /welcome/to/my/site
      HTML
    end
  end

  # /nuts/:number
  class NutsN
    def get(number)
      <<~HTML.chomp
        You got here by: /nuts/#{number}
      HTML
    end
  end

  # /gorp/:anything
  class GorpX
    def get(anything)
      <<~HTML.chomp
        You got here by: /gorp/#{anything}
      HTML
    end
  end

  # /nuts/:number/:anything
  class NutsNX
    def get(number, anything)
      <<~HTML.chomp
        You got here by: /nuts/#{number}/#{anything}
      HTML
    end
  end
end

run CampingExample.new
