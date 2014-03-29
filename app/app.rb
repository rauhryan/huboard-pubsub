require 'rubygems'
require 'bundler'

Bundler.require

module Huboard
  class PubSub < Sinatra::Base
    configure do
      disable :method_override
      disable :static
    end

    configure :production, :staging do 
      require "newrelic_rpm"
    end

    use Rack::Deflater
    register Sinatra::PubSub
  end
end
