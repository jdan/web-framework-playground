# frozen_string_literal: true

require_relative 'utils/string_based_routing'

##
# A Rack-compatible server which enables Sinatra-style Routing
class SinatraRouting < StringBasedRouting
  class << self
    def get(pattern, &block)
      add_route('GET', pattern, block: block)
    end
  end

  protected

  def execute_route(route)
    instance_eval(&route[:block])
  end
end
