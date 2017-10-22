require "spec_helper"

RSpec.describe Humi::Client do
  context ".new" do
    before do
      @client = Humi::Client.new(
        client_id:     'CID',
        client_secret: 'CS',
        access_token:  'AT'
      )
    end

    let(:json_header) { {'Content-Type' => 'application/json'} }

    describe ".user" do
      context "with user ID" do
        describe "get endpoint" do
          before do
            stub_get("api/v1/users/4").
              to_return(body: fixture("user_get.json").read, headers: json_header)
            @client.get_user(4)
          end

          example { expect(a_get("api/v1/users/4")).to have_been_made }
        end

        describe "fields on the user object" do
          before do
            stub_get("api/v1/users/4").
              to_return(body: fixture("user_get.json"), headers: json_header)
          end

          let(:user) { @client.get_user(4) }

          example { expect(user.legal_name).to eq "John F Smith" }
        end
      end
    end
  end
end
