# frozen_string_literal: true

require_relative '../routing/camping'

##
# A web server with camping-style routing
#
class CampingExample < CampingRouting
  # /
  class Index
    def get
      <<~HTML.chomp
        You got here by: /
      HTML
    end
  end

  # /router
  class Router
    def get
      <<~HTML.chomp
        Routing strategy: camping
      HTML
    end
  end

  # /welcome/to/my/site
  class WelcomeToMySite
    def get
      <<~HTML.chomp
        You got here by: /welcome/to/my/site
      HTML
    end
  end

  # /nuts/:number
  class NutsN
    def get(number)
      <<~HTML.chomp
        You got here by: /nuts/#{number}
      HTML
    end
  end

  # /gorp/:anything
  class GorpX
    def get(anything)
      <<~HTML.chomp
        You got here by: /gorp/#{anything}
      HTML
    end
  end

  # /nuts/:number/:anything
  class NutsNX
    def get(number, anything)
      <<~HTML.chomp
        You got here by: /nuts/#{number}/#{anything}
      HTML
    end
  end
end
