# frozen_string_literal: true

require 'rack/test'
require 'rack/builder'

%w[basic sinatra hanami camping].each do |name|
  describe name do
    include Rack::Test::Methods

    let(:app) do
      allow(ENV).to receive(:[]).with('ROUTING').and_return(name)
      ru_path = File.join(File.dirname(__FILE__), '../config.ru')
      Rack::Builder.parse_file(ru_path)
    end

    it 'responds to GET /' do
      get '/'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'You got here by: /'
    end

    it 'responds to GET /welcome/to/my/site' do
      get '/welcome/to/my/site'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'You got here by: /welcome/to/my/site'
    end

    it 'responds to GET /nuts/:number' do
      get '/nuts/7'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'You got here by: /nuts/7'
    end

    it 'responds to GET /gorp/:anything' do
      get '/gorp/jordan'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'You got here by: /gorp/jordan'
    end

    it 'responds to GET /nuts/:number/:anything' do
      get '/nuts/7/jordan'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'You got here by: /nuts/7/jordan'
    end

    it 'returns 404 when passing a string and expecting a number' do
      get '/nuts/hello/jordan'
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq '404 Not Found'
    end

    it 'returns 404 for unknown routes' do
      get '/path/with/multiple/segments'
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq '404 Not Found'
    end
  end
end
