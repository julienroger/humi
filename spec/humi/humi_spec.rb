require "spec_helper"

RSpec.describe Humi do
  before do
    Humi.reset
  end

  context "using client" do
    before do
      stub_get("api/v1/users/299792458").
        to_return(
          :body    => fixture("user_get.json"),
          :headers => { :content_type => "application/json; charset=utf-8" }
        )
    end

    describe "basic functionality" do
      before { Humi.get_user(299792458) }
      example { expect(a_get("api/v1/users/299792458")).to have_been_made }
    end
  end

  describe ".client" do
    example { expect(Humi.client).to be_a Humi::Client }
  end

  describe ".endpoint" do
    example { expect(Humi.endpoint).to eq Humi::Config::DEFAULT_ENDPOINT }
  end

  describe ".endpoint=" do
    before { Humi.endpoint = "http://abletribe.com" }
    example { expect(Humi.endpoint).to eq "http://abletribe.com" }
  end

  describe ".user_agent" do
    example { expect(Humi.user_agent).to eq Humi::Config::DEFAULT_USER_AGENT }
  end

  describe ".user_agent=" do
    before { Humi.user_agent = "Custom User Agent" }
    example { expect(Humi.user_agent).to eq "Custom User Agent" }
  end
end
