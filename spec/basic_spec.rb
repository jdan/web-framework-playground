require 'rack/test'
require 'rack/builder'

describe 'BasicExample' do
  include Rack::Test::Methods

  def app
    ru_path = File.join(File.dirname(__FILE__), '../basic/basic.ru')
    Rack::Builder.parse_file(ru_path)
  end

  it 'responds to GET /' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/Hello, world!/)
  end
end
