# frozen_string_literal: true

module Nuts
  ##
  # GET /nuts/:number
  class N
    def call(_env, number)
      "You got here by: /nuts/#{number}"
    end
  end
end
