ENV['APP_ENV'] = 'test'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/hooks/default'
require './app'

def app
  Sinatra::Application
end

def collect_resps
  resps = Array.new(100) { yield.body }
  resps.uniq.sort
end

PORTS = [4567, 4568].freeze
PORTS.each { |i| Process.spawn("ruby test_app.rb #{i} &") }
sleep 3

describe 'NanoTwitter Load Balancer' do
  include Rack::Test::Methods

  after(:all) do
    PORTS.each { |i| HTTParty.get("http://localhost:#{i}/exit") }
  end

  it 'can get from both nodes' do
    resps = collect_resps { get '/' }
    resps.must_equal(PORTS.map { |i| "GET:#{i}" })
  end

  it 'can post from both nodes' do
    resps = collect_resps { post '/' }
    resps.must_equal(PORTS.map { |i| "POST:#{i}" })
  end
end
