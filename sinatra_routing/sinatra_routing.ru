# frozen_string_literal: true

##
# A web server with Sinatra-style routing
#
# get '/' { 'Hello, world!' }
#
class SinatraRouting
  def initialize
    @params = {}
  end

  class << self
    def routes
      @routes ||= []
    end

    def get(pattern, &block)
      # Construct a new regex
      # Match the entire line
      # Replace :name with (?<name>\w+)
      re = Regexp.new('^' + pattern.gsub(/:(\w+)/, '(?<\1>\w+)') + '$')

      routes << { method: 'GET',
                  pattern: re,
                  block: block }
    end
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['PATH_INFO']
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
  get '/' do
    <<~HTML.chomp
      You got here by: /
    HTML
  end

  get '/welcome/to/my/site' do
    <<~HTML.chomp
      You got here by: /welcome/to/my/site
    HTML
  end

  get '/nuts/:number' do
    <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}
    HTML
  end

  get '/gorp/:anything' do
    <<~HTML.chomp
      You got here by: /gorp/#{params[:anything]}
    HTML
  end

  get '/nuts/:number/:anything' do
    <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}/#{params[:anything]}
    HTML
  end
end

run SinatraExample.new
