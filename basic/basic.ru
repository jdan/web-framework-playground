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
    when '/'
      html 'You got here by: /'
    when '/welcome/to/my/site'
      html 'You got here by: /welcome/to/my/site'
    when %r{^/nuts/(?<number>\d+)$}
      number = Regexp.last_match.named_captures['number']
      html "You got here by: /nuts/#{number}"
    when %r{^/gorp/(?<anything>\w+)$}
      anything = Regexp.last_match.named_captures['anything']
      html "You got here by: /gorp/#{anything}"
    when %r{^/nuts/(?<number>\d+)/(?<anything>\w+)$}
      number = Regexp.last_match.named_captures['number']
      anything = Regexp.last_match.named_captures['anything']
      html "You got here by: /nuts/#{number}/#{anything}"
    else
      not_found
    end
  end
end

run BasicExample.new
