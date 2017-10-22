require "spec_helper"

module MiddlewareExampleGroup
  def self.included(base)
    base.class_eval do
      let(:app)              { double("@app", call: nil)            }
      let(:env)              { { request_headers: {}, response_headers: {} } }
      let(:retries)          { 3 }
      let(:endpoint)         { "https://www.humi.ca/api" }
      let(:options)          { { endpoint: endpoint } }
      let(:client)           { Humi::Client.new(options) }
      let(:auth_callback)    { double(Proc) }
      let(:success_response) { JSON.parse(fixture("auth_success_response.json").read) }

      subject(:middleware) { described_class.new app, client, options }
    end
  end

  RSpec.configure do |config|
    config.include self, example_group: { file_path: %r{spec/support/middleware} }
  end
end

RSpec.shared_examples_for "authentication middleware" do
  describe ".authenticate!" do
    after { expect(request).to have_been_requested }

    context "when successful" do
      let!(:request) { success_request }

      describe "@options" do
        subject { options }

        before { middleware.authenticate! }

        example { expect(subject[:endpoint]).to eq "https://www.humi.ca/api" }
      end

      context "when an auth_callback is specified" do
        before(:each) do
          options.merge!(auth_callback: auth_callback)
        end

        it "calls the authentication callback with the response body" do
          expect(auth_callback).to receive(:call).with(success_response)
          middleware.authenticate!
        end
      end
    end

    context "when unsuccessful" do
      let!(:request) { fail_request }

      it "raises an exception" do
        expect {
          middleware.authenticate!
        }.to raise_error Humi::AuthenticationError, /^invalid_grant: .*/
      end

      context "when an auth_callback is specified" do
        before(:each) do
          options.merge!(auth_callback: auth_callback)
        end

        it "does not call the authentication callback" do
          expect(auth_callback).not_to receive(:call)
          expect do
            middleware.authenticate!
          end.to raise_error
        end
      end
    end
  end
end
