# frozen_string_literal: true

##
# GET /router
class Router
  def call(_env)
    'Routing strategy: file_system'
  end
end
