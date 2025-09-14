# frozen_string_literal: true

##
# GET /router
module Router
  def call(_env)
    'Routing strategy: file_system'
  end
end
