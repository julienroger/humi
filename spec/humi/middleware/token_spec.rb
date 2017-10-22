require "spec_helper"

RSpec.describe Humi::Middleware::Authentication::Token do
  let(:options) do
    {
      refresh_token: "refresh_token",
      client_id:     "client_id",
      client_secret: "client_secret",
    }
  end

  it_behaves_like "authentication middleware" do
    let(:success_request) do
      stub_login_request(
        body: "grant_type=refresh_token&refresh_token=refresh_token&" \
                 "client_id=client_id&client_secret=client_secret"
      ).to_return(status: 200, body: fixture("auth_success_response.json"))
    end

    let(:fail_request) do
      stub_login_request(
        body: "grant_type=refresh_token&refresh_token=refresh_token&" \
                 "client_id=client_id&client_secret=client_secret"
      ).to_return(status: 400, body: fixture("refresh_error_response.json"))
    end
  end
end
