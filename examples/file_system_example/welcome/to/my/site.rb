# frozen_string_literal: true

module Welcome
  module To
    module My
      ##
      # GET /welcome/to/my/site
      module Site
        def call(_env)
          'You got here by: /welcome/to/my/site'
        end
      end
    end
  end
end
