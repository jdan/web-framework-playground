# frozen_string_literal: true

##
# A basic Rack server
#
class BasicExample
  def call(env)
    if env['PATH_INFO'] == '/'
      [200, { 'content-type' => 'text/html' },
       ['<h1>Hello, from index.html</h1><a href="/jordan">Say hi to Jordan</a>']]
    elsif env['PATH_INFO'] =~ %r{^/(?<name>\w+)$}
      [200, { 'content-type' => 'text/html' },
       ["<h1>Hello, #{Regexp.last_match.named_captures['name']}!</h1>"]]
    else
      [404, { 'content-type' => 'text/html' },
       ['<h1>404 Not Found</h1>']]
    end
  end
end

run BasicExample.new
