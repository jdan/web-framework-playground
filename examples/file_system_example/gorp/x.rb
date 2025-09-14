# frozen_string_literal: true

module Gorp
  ##
  # GET /gorp/:anything
  module X
    def call(_env, anything)
      "You got here by: /gorp/#{anything}"
    end
  end
end
