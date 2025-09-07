# frozen_string_literal: true

require_relative '../routing/hanami'

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
