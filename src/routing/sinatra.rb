# frozen_string_literal: true

require_relative 'util/string_based_routing'

##
# A Rack-compatible server which enables Sinatra-style Routing
class SinatraRouting < StringBasedRouting
  class << self
    def get(pattern, &block)
      add_route('GET', pattern, block: block)
    end
  end

  protected

  def execute_route(route)
    instance_eval(&route[:block])
  end
end

##
# A web server with Sinatra-style routing
#
# get '/' { 'Hello, world!' }
#
class SinatraExample < SinatraRouting
  get '/' do
    html <<~HTML.chomp
      You got here by: /
    HTML
  end

  get '/router' do
    html <<~HTML.chomp
      Routing strategy: sinatra
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
