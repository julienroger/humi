require "spec_helper"

RSpec.describe Humi::Config do
  describe "#configure" do
    before do
      Humi.configure do |config|
        config.client_id     = "client-id"
        config.client_secret = "super-secret-token"
      end
    end

    example { expect(Humi.client_id)    .to eq "client-id" }
    example { expect(Humi.client_secret).to eq "super-secret-token" }
  end
end
