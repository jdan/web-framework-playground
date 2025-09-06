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

  class << self
    def routes
      @routes ||= []
    end

    def get(pattern, to:)
      # Construct a new regex
      # Match the entire line
      # Replace :name with (?<name>\w+)
      re = Regexp.new('^' + pattern.gsub(/:(\w+)/, '(?<\1>\w+)') + '$')

      routes << { method: 'GET',
                  pattern: re,
                  method_name: to }
    end
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] && route[:pattern] =~ env['PATH_INFO']
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
  get '/welcome/to/my/site', to: :welcome
  get '/nuts/:number', to: :nuts_n
  get '/gorp/:anything', to: :gorp_x
  get '/nuts/:number/:anything', to: :nuts_n_x

  def index
    <<~HTML.chomp
      You got here by: /
    HTML
  end

  def welcome
    <<~HTML.chomp
      You got here by: /welcome/to/my/site
    HTML
  end

  def nuts_n
    <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}
    HTML
  end

  def gorp_x
    <<~HTML.chomp
      You got here by: /gorp/#{params[:anything]}
    HTML
  end

  def nuts_n_x
    <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}/#{params[:anything]}
    HTML
  end
end

run HanamiExample.new
