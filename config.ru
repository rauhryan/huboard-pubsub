if File.exists?("./.env") 
  require 'dotenv'
  Dotenv.load
end

require './app/app'

run Huboard::PubSub
