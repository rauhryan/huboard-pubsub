require 'rubygems'
require 'bundler'
require 'cgi'
require 'octokit'

Octokit.api_endpoint = ENV["GITHUB_API_ENDPOINT"] || "https://api.github.com"

Bundler.require

module Huboard
  class PubSub < Sinatra::Base

    set :session_secret, ENV["SESSION_SECRET"]

    configure do
      enable :sessions
      disable :method_override
      disable :static
    end

    configure :production, :staging do 
      require "newrelic_rpm"
    end



    use Rack::Deflater
    register Sinatra::PubSub

    Sinatra::PubSub.set(
      :origin, ENV["CORS_DOMAIN"] || "http://localhost:9393"
    )

    Sinatra::PubSub.set :session_secret, ENV["SESSION_SECRET"]

    if false

    Sinatra::PubSub::App.before do

      begin
        session_id = Rack::Session::Cookie.new self,
          :key => 'rack.session',
          :path => '/',
          :secret => settings.session_secret,
          :expire_after => 2592000,
          :secure => settings.production?

        session_hash = Rack::Session::Abstract::SessionHash.new session_id, env

        warden = session_hash["warden.user.private.key"] || session_hash["warden.user.default.key"] 
        halt 403 if warden.nil?

        client = Octokit::Client.new :access_token => warden["token"]

        response = client.agent.call(:get, "./")
        halt [403, "Bad auth token"] unless response.status == 200

      rescue => e
        puts "==== halt ===="
        halt [403, "Failed to pass authentication"]
      end

    end
    end
  end
end
