# Searcher Micro-Service (port 8083)

require 'sinatra'
PORT = ARGV[0].to_i
set :port, PORT

get '/' do
  "GET:#{PORT}"
end

post '/' do
  "POST:#{PORT}"
end

get '/exit' do
  Sinatra::Application.quit!
end
