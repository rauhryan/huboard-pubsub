require 'rubygems'
require 'bundler'

Bundler.require

module Huboard
  class PubSub < Sinatra::Base
    configure do
      disable :method_override
      disable :static
    end

    use Rack::Deflater
    register Sinatra::PubSub
  end
end
