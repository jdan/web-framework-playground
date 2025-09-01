# frozen_string_literal: true

##
# A web server with Hanami-style routing
#
# get '/', to: :index
#
class HanamiRouting
  def initialize
    @params = {}
  end

  def self.get(pattern, to:)
    # Construct a new regex
    # Match the entire line
    # Replace :name with (?<name>\w+)
    re = Regexp.new('^' + pattern.gsub(/:(\w+)/, '(?<\1>\w+)') + '$')

    @routes ||= []
    @routes << { method: 'GET',
                 pattern: re,
                 method_name: to }
  end

  def self.routes
    @routes || []
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['REQUEST_PATH']
    end

    if route
      # Declare `params` as a hash from symbol => value
      # Then expose it as a singleton_method for calling the route's block
      params = {}
      Regexp.last_match.named_captures.each do |name, value|
        params[name.to_sym] = value
      end
      define_singleton_method('params', -> { params })

      [200, { 'content-type' => 'text/html' }, [send(route[:method_name])]]
    else
      [404, { 'content-type' => 'text/html' }, ['<h1>404 Not Found</h1>']]
    end
  end
end

class HanamiExample < HanamiRouting
  get '/', to: :index
  get '/:name', to: :name

  def index
    <<~HTML
      <body>
        <h1>Hello, from index.html</h1>
        <a href="/jordan">Say hi to Jordan</a>
      </body>
    HTML
  end

  def name
    <<~HTML
      <body>
        <h1>Hello, #{params[:name]}!</h1>
      </body>
    HTML
  end
end

run HanamiExample.new
