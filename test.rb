# This file is a DRY way to set all of the requirements
# that our tests will need, as well as a before statement
# that purges the database and creates fixtures before every test

ENV['APP_ENV'] = 'test'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/hooks/default'
require './app'

def app
  Sinatra::Application
end

PORTS = [4567, 4568].freeze

describe 'NanoTwitter Load Balancer' do
  include Rack::Test::Methods

  before(:all) do
    PORTS.each { |i| Process.spawn("ruby test_app.rb #{i} &") }
    sleep 3
  end

  after(:all) do
    PORTS.each { |i| HTTParty.get("http://localhost:#{i}/exit") }
  end

  it 'can get from both nodes' do
    resps = []
    100.times do
      get '/'
      resps << last_response.body
    end
    resps.uniq.sort.must_equal(PORTS.map { |i| "GET:#{i}" })
  end

  it 'can post from both nodes' do
    resps = []
    100.times do
      post '/'
      resps << last_response.body
    end
    resps.uniq.sort.must_equal(PORTS.map { |i| "POST:#{i}" })
  end
end
