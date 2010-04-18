#
#    foohttpd - a silly tiny webserver
#    Copyright (C) 2010 blawl 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'eventmachine'
require 'request.rb'

class Foohttp
  module EvMaDesc 
    def post_init
    #  puts "Recived connection"
    end
    def receive_data request
      HandleHTTP(request)
      #close_connection
    end
  end

  def initialize(address, port)
    puts "Starting foohttpd webserver, listening on #{address}:#{port}"
    EventMachine::run {
      EventMachine::start_server address,port, EvMaDesc 
    }
  end
end

