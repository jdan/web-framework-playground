# frozen_string_literal: true

module Nuts
  # TODO: Kind of sus that N has to be a class again
  class N
    ##
    # GET /nuts/:number/:anything
    class X
      def call(_env, number, anything)
        "You got here by: /nuts/#{number}/#{anything}"
      end
    end
  end
end
