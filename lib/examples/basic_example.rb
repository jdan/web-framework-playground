# frozen_string_literal: true

##
# A basic Rack server
#
class BasicExample
  def html(body)
    [200, { 'content-type' => 'text/html' }, [body]]
  end

  def not_found
    [404, { 'content-type' => 'text/html' }, ['404 Not Found']]
  end

  def call(env)
    case env['PATH_INFO']
    when '/' then html 'You got here by: /'
    when '/router' then html 'Routing strategy: basic'
    when '/welcome/to/my/site' then html 'You got here by: /welcome/to/my/site'
    when %r{^/nuts/(?<number>\d+)$} then html "You got here by: /nuts/#{::Regexp.last_match(1)}"
    when %r{^/gorp/(?<anything>\w+)$} then html "You got here by: /gorp/#{::Regexp.last_match(1)}"
    when %r{^/nuts/(?<number>\d+)/(?<anything>\w+)$}
      html "You got here by: /nuts/#{::Regexp.last_match(1)}/#{::Regexp.last_match(2)}"
    else not_found
    end
  end
end
