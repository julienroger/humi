module RequestHelpers
  module InstanceMethods
    def a_delete(path)
      a_request(:delete, File.join(Humi.endpoint, path))
    end

    def a_get(path)
      a_request(:get, File.join(Humi.endpoint, path))
    end

    def a_post(path)
      a_request(:post, File.join(Humi.endpoint, path))
    end

    def a_put(path)
      a_request(:put, File.join(Humi.endpoint, path))
    end

    def stub_get(path)
      stub_request(:get, File.join(Humi.endpoint, path))
    end

    def stub_post(path)
      stub_request(:post, File.join(Humi.endpoint, path))
    end

    def stub_put(path)
      stub_request(:put, File.join(Humi.endpoint, path))
    end

    def stub_delete(path)
      stub_request(:delete, File.join(Humi.endpoint, path))
    end

    def stub_login_request(*)
      stub_request(:post, File.join(Humi.endpoint, "/oauth/token"))
    end

    def fixture(file)
      File.new(fixture_path + '/' + file)
    end

    def fixture_path
      File.expand_path("../../fixtures", __FILE__)
    end
  end

  module ClassMethods
    def requests(endpoint, options = {})
      before do
        (@requests ||= []) << stub_api_request(endpoint, options)
      end

      after do
        @requests.each { |request| expect(request).to have_been_requested }
      end
    end
  end
end

RSpec.configure do |config|
  config.include RequestHelpers::InstanceMethods
  config.extend RequestHelpers::ClassMethods
end