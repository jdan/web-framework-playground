# frozen_string_literal: true

##
# A web server with Sinatra-style routing
#
class SinatraRouting
  def initialize
    @routes = []
    @params = {}
    route
  end

  def route
    raise NotImplementedError
  end

  def get(pattern, &block)
    # Construct a new regex
    # Match the entire line
    # Replace :name with (?<name>\w+)
    re = Regexp.new('^' + pattern.gsub(/:(\w+)/, '(?<\1>\w+)') + '$')

    @routes << { method: 'GET',
                 pattern: re,
                 block: block }
  end

  def call(env)
    route = @routes.find do |route|
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

      [200, { 'content-type' => 'text/html' }, [instance_eval(&route[:block])]]
    else
      [404, { 'content-type' => 'text/html' }, ['<h1>404 Not Found</h1>']]
    end
  end
end

class SinatraExample < SinatraRouting
  def route
    get '/' do
      <<~HTML
        <body>
          <h1>Hello, from index.html</h1>
          <a href="/jordan">Say hi to Jordan</a>
        </body>
      HTML
    end

    get '/:name' do
      <<~HTML
        <body>
          <h1>Hello, #{params[:name]}!</h1>
        </body>
      HTML
    end
  end
end

run SinatraExample.new
