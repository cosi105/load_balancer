# Load Balancer Micro-Service (port 1111)

require 'bundler'
Bundler.require

if Sinatra::Base.production?
  SERVERS = ENV['SERVERS'].split
else
  set :port, 1111
  ports = [4567, 4568]
  SERVERS = ports.map { |port| "http://localhost:#{port}" }
end

get %r{\/.*} do
  server = SERVERS.sample
  HTTParty.get("#{server}#{request.path}", query: request.params).parsed_response
end

post %r{\/.*} do
  server = SERVERS.sample
  HTTParty.post("#{server}#{request.path}", query: request.params).parsed_response
end
