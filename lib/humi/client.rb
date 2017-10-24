module Humi
  class Client < API
    Dir[File.expand_path("../client/*.rb", __FILE__)].each{|f| require f}

    include Humi::Client::Tokens
    include Humi::Client::Users
    include Humi::Client::Companies
    include Humi::Client::Offices
    include Humi::Client::Benefits
  end
end
