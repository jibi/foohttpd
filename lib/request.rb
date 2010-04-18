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
#

WEBROOT="lolwebroot"

def SendString(str)
  len = str.length
  EventMachine::send_data @signature, str, len
end

def HandleHTTP(request)
  request_lines = request.split("\r\n")
  method  = request_lines[0].split( )[0]
    
  case method
    when "GET"
      HandleGET(request)
    when "POST"
     #HandlePost(request)
  end
end

def HandleGET(request)
  request_lines = request.split("\r\n")
  uri = request_lines[0].split( )[1]

  if uri =~ /\.\.\//
    puts "Someone is trying something nasty :|"
    return
  end

  uri = "/index.html" if uri == "/"

  file = "#{WEBROOT}#{uri}"
  puts "File: #{file}"

  if ! File.exist?(file)
    puts "OMG YOU HAZ FAIL"
    #send 404
    return
  end

  if uri =~ /\.html$/
    content_type="text/html"
  elsif uri =~ /\.js$/
   content_type="text/javascript"
  elsif uri =~ /\.css$/
    content_type="text/css"
  elsif uri =~ /\.png$/
    content_type="image/png"
  elsif uri =~ /\.jpg$/
    content_type="image/jpeg"
  end

  content_length = File.size(file)

  SendString("HTTP/1.0 200 OK\r\n")
  SendString("Content-Type: #{content_type}\r\n")
  SendString("Content-Lenght: #{content_length}\r\n")
  SendString("Server: foohttpd/0.01-a\r\n\r\n")

  page = File.open(file, File::RDONLY) 
  page.readlines.each { |line| SendString(line) }
  
end

