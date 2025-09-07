# frozen_string_literal: true

require_relative 'util/string_based_routing'

##
# A rack-compatible server which enables Hanami-style routing
class HanamiRouting < StringBasedRouting
  class << self
    def get(pattern, to:)
      add_route('GET', pattern, method_name: to)
    end
  end

  protected

  def execute_route(route)
    send(route[:method_name])
  end
end
