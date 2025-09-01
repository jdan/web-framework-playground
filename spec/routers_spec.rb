require 'rack/test'
require 'rack/builder'

{
  'BasicExample' => '../basic/basic.ru',
  'SinatraExample' => '../sinatra_routing/sinatra_routing.ru',
  'HanamiExample' => '../hanami_routing/hanami_routing.ru',
  'CampingExample' => '../camping_routing/camping_routing.ru'
}.each do |name, relative_path|
  describe name do
    include Rack::Test::Methods

    let(:app) do
      # Load the actual app
      ru_path = File.join(File.dirname(__FILE__), relative_path)
      actual_app = Rack::Builder.parse_file(ru_path)

      # Create a wrapper that sets REQUEST_PATH from PATH_INFO
      lambda do |env|
        env['REQUEST_PATH'] = env['PATH_INFO']
        actual_app.call(env)
      end
    end

    it 'responds to GET /' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to match(/Hello, from index.html/)
      expect(last_response.body).to match(%r{<a href="/jordan">Say hi to Jordan</a>})
    end

    it 'responds to GET /:name' do
      get '/jordan'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to match(/Hello, jordan!/)
    end

    it 'returns 404 for unknown routes' do
      get '/path/with/multiple/segments'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to match(/404 Not Found/)
    end
  end
end
