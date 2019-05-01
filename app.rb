# Searcher Micro-Service (port 8083)

require 'bundler'
Bundler.require

if Sinatra::Base.production?
  SERVERS = ENV['SERVERS'].split
else
  set :port, 1111
  SERVERS = %w[http://localhost:4567 http://localhost:4568]
end

get %r{\/.*} do
  server = SERVERS.sample
  HTTParty.get("#{server}#{request.path}", query: request.params).parsed_response
end

post %r{\/.*} do
  server = SERVERS.sample
  HTTParty.post("#{server}#{request.path}", query: request.params).parsed_response
end
