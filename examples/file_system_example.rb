# frozen_string_literal: true

require_relative '../lib/routing/file_system'

##
# An example of a file-system based web server, where files in `root`
# are themselves mini-rack servers with the path hard-coded
#
#   examples/file_system_example
#   ├── gorp
#   │   └── x.rb
#   ├── index.rb
#   ├── nuts
#   │   ├── n
#   │   │   └── x.rb
#   │   └── n.rb
#   ├── router.rb
#   └── welcome
#       └── to
#           └── my
#               └── site.rb
#
class FileSystemExample < FileSystemRouting
  root 'file_system_example'
end
