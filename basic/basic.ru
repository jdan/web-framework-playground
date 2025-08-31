# frozen_string_literal: true

##
# A basic Rack server
#
class BasicExample
  def call(_env)
    [200, { 'content-type' => 'text/html' }, ['<h1>Hello, world!</h1>']]
  end
end

run BasicExample.new
