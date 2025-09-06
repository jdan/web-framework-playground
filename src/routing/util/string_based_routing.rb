# frozen_string_literal: true

##
# Base class for rack-compatible string-based Routing
#
# Used to define routes such as /posts, /posts/:index, and /posts/:index/edit
class StringBasedRouting
  def initialize
    @params = {}
  end

  class << self
    def routes
      @routes ||= []
    end

    protected

    def add_route(method, pattern, options = {})
      # Construct a new regex
      # Match the entire line
      # Replace :name with (?<name>\w+)
      re = Regexp.new("^#{pattern.gsub(/:(\w+)/, '(?<\1>\w+)')}$")
      routes << { method: method.upcase,
                  pattern: re }.merge(options)
    end
  end

  def html(doc)
    [200, { 'content-type' => 'text/html' }, [doc]]
  end

  def not_found(doc)
    [404, { 'content-type' => 'text/html' }, [doc]]
  end

  ##
  # Declare `params` as a hash from symbol => value
  # Then expose it as a singleton_method for calling the route's block
  def set_params!(named_captures)
    params = {}
    named_captures&.each do |name, value|
      params[name.to_sym] = value
    end
    define_singleton_method('params', -> { params })
  end

  def call(env)
    route = self.class.routes.find do |route|
      route[:method] == env['REQUEST_METHOD'] and route[:pattern] =~ env['PATH_INFO']
    end

    return not_found('404 Not Found') unless route

    set_params!(Regexp.last_match.named_captures)
    execute_route(route)
  end

  protected

  def execute_route(route)
    raise NotImplementedError, 'Subclasses must implement execute_route'
  end
end
