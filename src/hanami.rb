# frozen_string_literal: true

##
# A rack-compatible server which enables Hanami-style routing
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
      re = Regexp.new("^#{pattern.gsub(/:(\w+)/, '(?<\1>\w+)')}$")
      routes << { method: 'GET',
                  pattern: re,
                  method_name: to }
    end
  end

  def html(doc)
    [200, { 'content-type' => 'text/html' }, [doc]]
  end

  def not_found(doc)
    [404, { 'content-type' => 'text/html' }, [doc]]
  end

  ##
  # Declare `params` as a hash from symbol => value
  # Then expose it as a singleton_method for calling the route's block
  def set_params!(named_captures)
    params = {}
    named_captures.each do |name, value|
      params[name.to_sym] = value
    end
    define_singleton_method('params', -> { params })
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['PATH_INFO']
    end

    return not_found('404 Not Found') unless route

    set_params!(Regexp.last_match.named_captures)
    send(route[:method_name])
  end
end

##
# A web server with Hanami-style routing
#
# get '/', to: :index
#
class HanamiExample < HanamiRouting
  get '/', to: :index
  get '/router', to: :router
  get '/welcome/to/my/site', to: :welcome
  get '/nuts/:number', to: :nuts_n
  get '/gorp/:anything', to: :gorp_x
  get '/nuts/:number/:anything', to: :nuts_n_x

  def index
    html <<~HTML.chomp
      You got here by: /
    HTML
  end

  def router
    html <<~HTML.chomp
      Routing strategy: hanami
    HTML
  end

  def welcome
    html <<~HTML.chomp
      You got here by: /welcome/to/my/site
    HTML
  end

  def nuts_n
    return not_found '404 Not Found' unless /^\d+$/ =~ params[:number]

    html <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}
    HTML
  end

  def gorp_x
    html <<~HTML.chomp
      You got here by: /gorp/#{params[:anything]}
    HTML
  end

  def nuts_n_x
    return not_found '404 Not Found' unless /^\d+$/ =~ params[:number]

    html <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}/#{params[:anything]}
    HTML
  end
end
