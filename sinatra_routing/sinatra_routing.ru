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
      re = Regexp.new("^#{pattern.gsub(/:(\w+)/, '(?<\1>\w+)')}$")
      routes << { method: 'GET',
                  pattern: re,
                  block: block }
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
    instance_eval(&route[:block])
  end
end

class SinatraExample < SinatraRouting
  get '/' do
    html <<~HTML.chomp
      You got here by: /
    HTML
  end

  get '/welcome/to/my/site' do
    html <<~HTML.chomp
      You got here by: /welcome/to/my/site
    HTML
  end

  get '/nuts/:number' do
    next not_found '404 Not Found' unless /^\d+$/ =~ params[:number]

    html <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}
    HTML
  end

  get '/gorp/:anything' do
    html <<~HTML.chomp
      You got here by: /gorp/#{params[:anything]}
    HTML
  end

  get '/nuts/:number/:anything' do
    next not_found '404 Not Found' unless /^\d+$/ =~ params[:number]

    html <<~HTML.chomp
      You got here by: /nuts/#{params[:number]}/#{params[:anything]}
    HTML
  end
end

run SinatraExample.new
