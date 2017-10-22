require "spec_helper"
require "humi/authentication"

RSpec.describe Humi::Authentication do
  let(:client) { Humi::Client.new(options) }
  let(:options) { Hash.new }

  describe ".authenticate!" do
    subject(:authenticate!) { client.authenticate! }

    context "when there is no authentication middleware" do
      before { allow(client).to receive(:authentication_middleware).and_return(nil) }

      it "raises an error" do
        expect { authenticate! }.to raise_error Humi::AuthenticationError,
                                                "No authentication middleware present"
      end
    end

    context "when there is authentication middleware" do
      let(:authentication_middleware) { double("Authentication Middleware") }
      subject(:result) { client.authenticate! }

      it "authenticates using the middleware" do
        allow(client).to receive(:authentication_middleware).and_return(authentication_middleware)
        allow(client).to receive(:options).and_return(options)
        expect(authentication_middleware).to receive(:new).
          with(nil, client, client.options).
          and_return(double(authenticate!: "humi"))
        expect(result).to eq "humi"
      end
    end
  end

  describe ".authentication_middleware" do
    subject { client.authentication_middleware }

    context "when username and password options are provided" do
      before { allow(client).to receive(:username_password?).and_return(true) }

      it { is_expected.to eq Humi::Middleware::Authentication::Password }
    end

    context "when oauth options are provided" do
      before do
        allow(client).to receive(:username_password?).and_return(false)
        allow(client).to receive(:oauth_refresh?).and_return(true)
      end

      it { is_expected.to eq Humi::Middleware::Authentication::Token }
    end
  end

  describe ".username_password?" do
    subject { client.username_password? }

    context "when username and password options are provided" do
      let(:options) do
        {
          username:      "username",
          password:      "password",
          client_id:     "client-id",
          client_secret: "client-secret"
        }
      end

      it { is_expected.to be true }
    end

    context "when username and password options are not provided" do
      it { is_expected.not_to be true }
    end
  end

  describe ".oauth_refresh?" do
    subject { client.oauth_refresh? }

    context "when oauth options are provided" do
      let(:options) do
        {
          refresh_token: "token",
          client_id:     "client",
          client_secret: "secret"
        }
      end

      it { is_expected.to be true }
    end

    context "when oauth options are not provided" do
      it { is_expected.not_to be true }
    end
  end
end
