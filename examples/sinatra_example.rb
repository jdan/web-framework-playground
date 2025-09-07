# frozen_string_literal: true

require_relative '../lib/routing/sinatra'

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
