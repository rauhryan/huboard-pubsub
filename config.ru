require './app/app'

configure :production, :staging do 
  require "newrelic_rpm"
end

run Huboard::PubSub
