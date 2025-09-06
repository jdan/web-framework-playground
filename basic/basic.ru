# frozen_string_literal: true

##
# A basic Rack server
#
class BasicExample
  def call(env)
    if env['PATH_INFO'] == '/'
      [200, { 'content-type' => 'text/html' },
       ['You got here by: /']]
    elsif env['PATH_INFO'] == '/welcome/to/my/site'
      [200, { 'content-type' => 'text/html' },
       ['You got here by: /welcome/to/my/site']]
    elsif env['PATH_INFO'] =~ %r{^/nuts/(?<number>\d+)$}
      [200, { 'content-type' => 'text/html' },
       ["You got here by: /nuts/#{Regexp.last_match.named_captures['number']}"]]
    elsif env['PATH_INFO'] =~ %r{^/gorp/(?<anything>\w+)$}
      [200, { 'content-type' => 'text/html' },
       ["You got here by: /gorp/#{Regexp.last_match.named_captures['anything']}"]]
    elsif env['PATH_INFO'] =~ %r{^/nuts/(?<number>\d+)/(?<anything>\w+)$}
      [200, { 'content-type' => 'text/html' },
       ["You got here by: /nuts/#{Regexp.last_match.named_captures['number']}/#{Regexp.last_match.named_captures['anything']}"]]
    else
      [404, { 'content-type' => 'text/html' },
       ['<h1>404 Not Found</h1>']]
    end
  end
end

run BasicExample.new
