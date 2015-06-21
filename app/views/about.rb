#
# metaflop - web interface
# © 2012 by alexis reigel
# www.metaflop.com
#
# licensed under gpl v3
#

class App < Sinatra::Base
  module Views
    class About < Layout
      def current_year
        Time.new.year
      end
    end
  end
end
