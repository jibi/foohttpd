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
require 'socket'
require 'request.rb'

class Foohttp
  class Conn < EventMachine::Connection
    def post_init
      address = Socket.unpack_sockaddr_in(get_peername)[1]
      puts "Recived request from #{address}"
    end
    def receive_data request
      HandleHTTP(request)
      close_connection_after_writing
    end
  end

  def initialize(address, port)
    puts "Starting foohttpd webserver =^_^="
    puts "Listening on #{address}:#{port}"
    EventMachine.run {
      EventMachine.start_server(address,port,Conn)
    }
  end
end

