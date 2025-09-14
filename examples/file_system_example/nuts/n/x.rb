# frozen_string_literal: true

module Nuts
  module N
    ##
    # GET /nuts/:number/:anything
    module X
      def call(_env, number, anything)
        "You got here by: /nuts/#{number}/#{anything}"
      end
    end
  end
end
