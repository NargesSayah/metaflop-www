#
# metaflop - web interface
# © 2012 by alexis reigel
# www.metaflop.com
#
# licensed under gpl v3
#

require './app/views/error'

class App < Sinatra::Base
  module Views
    class Error404 < Error
    end
  end
end
