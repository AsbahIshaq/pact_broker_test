require "timecop"

TESTED_PATHS = []

WEBHOOK_ROUTES_REQURING_A_TEST = PactBroker.routes
      .select { | route | route[:path].include?("webhook") }

RSpec.describe "webhook routes" do
  before do
    td.set_now_date_time(DateTime.new(2021, 9, 1, 10, 0, 0))
      .create_consumer("Foo")
      .create_provider("Bar")
      .create_consumer_version("2")
      .create_pact(json_content: { integrations: [] }.to_json )
      .create_verification(provider_version: "3")
      .create_webhook(uuid: "d2181b32-8b03-4daf-8cc0-d9168b2f6fac")
      .create_triggered_webhook(uuid: "6cd5cc48-db3c-4a4c-a36d-e9bedeb9d91e")
      .create_webhook_execution
  end

  before do
    if ENV["DEBUG"] == "true"
      PactBroker.routes.find{ | route| route[:path] == path_template }
    end
    TESTED_PATHS << path_template
  end

  after(:all) do
    missed_routes = WEBHOOK_ROUTES_REQURING_A_TEST.reject { | route | TESTED_PATHS.include?(route[:path]) }

    if missed_routes.any? && ENV["DEBUG"] != "true"
      puts "WEBHOOK ROUTES MISSING COVERAGE:"
      puts missed_routes.to_yaml
    end
  end

  let(:category) { "Webhooks" }
  let(:pact_version_sha) { PactBroker::Pacts::PactVersion.last.sha }
  let(:triggered_webhook_uuid) { PactBroker::Webhooks::TriggeredWebhook.last.trigger_uuid }
  let(:webhook_uuid) { PactBroker::Webhooks::TriggeredWebhook.last.webhook.uuid }

  let(:parameter_values) do
    {
      pact_version_sha: pact_version_sha,
      provider_name: "Bar",
      consumer_name: "Foo",
      consumer_version_number: "2",
      provider_version_number: "3",
      trigger_uuid: triggered_webhook_uuid,
      verification_number: "1"
    }
  end

  let(:custom_parameter_values) do
    {

    }
  end

  let(:rack_headers) do
    {
      "ACCEPT" => "application/hal+json"
    }
  end

  let(:http_params) { {} }
  let(:http_method) { "GET" }

  let(:path) do
    parameter_values.merge(custom_parameter_values).inject(path_template) do | new_path, (name, value) |
      new_path.gsub(/:#{name}(\/|$)/, value + '\1')
    end
  end

  let(:approval_request_example_name) do | example |
    "docs_webhooks_" + pact_broker_example_name.gsub(" ", "_") + "_" + http_method
  end

  let(:pact_broker_example_name) do | example |
    example.example_group.parent_groups[-2].description
  end

  def remove_deprecated_links(thing)
    case thing
    when Hash then remove_deprecated_links_from_hash(thing)
    when Array then thing.collect { |value| remove_deprecated_links(value) }
    else thing
    end
  end

  def remove_deprecated_links_from_hash(body)
    body.each_with_object({}) do | (key, value), new_body |
      if key == "_links"
        links = value.select do | key, _value |
          key.start_with?("pb:", "self", "next", "previous", "curies")
        end
        new_body["_links"] = links
      else
        new_body[key] = remove_deprecated_links(value)
      end
    end
  end

  subject { send(http_method.downcase, path, http_params, rack_headers) }

  shared_examples "request" do
    it "returns a body" do | example |
      subject
      expectated_body = subject.headers["Content-Type"]&.include?("json") && subject.body && subject.body != "" ? remove_deprecated_links(JSON.parse(subject.body)) : subject.body
      expected_response = {
        status: subject.status,
        headers: determinate_headers(subject.headers),
        body: expectated_body
      }
      request = {
        method: http_method,
        path_template: path_template,
        path: path,
        headers: rack_env_to_http_headers(rack_headers)
      }

      to_approve = {
        category: category,
        name: pact_broker_example_name,
        request: request,
        response: expected_response
      }
      Approvals.verify(to_approve, :name => approval_request_example_name, format: :json)
    end
  end

  shared_examples "supports GET" do
    describe "GET" do
      it "supports GET" do
        expect(subject.status).to eq 200
      end

      include_examples "request"
    end
  end


  shared_examples "supports POST" do
    describe "POST" do
      let(:http_method) { "POST" }
      let(:rack_headers) do
        {
          "CONTENT_TYPE" => "application/json",
          "ACCEPT" => "application/hal+json"
        }
      end

      include_examples "request"
    end
  end

  shared_examples "supports OPTIONS" do
    describe "OPTIONS" do
      let(:http_method) { "OPTIONS" }

      include_examples "request"
    end
  end


  describe "Verification webhooks" do
    let(:path_template) do
      "/pacts/provider/:provider_name/consumer/:consumer_name/pact-version/:pact_version_sha/verification-results/:verification_number/triggered-webhooks"
    end

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Pact triggered webhooks" do
    let(:path_template) do
      "/pacts/provider/:provider_name/consumer/:consumer_name/version/:consumer_version_number/triggered-webhooks"
    end

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Pact webhooks" do
    let(:path_template) do
      "/pacts/provider/:provider_name/consumer/:consumer_name/webhooks"
    end

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhooks status" do
    let(:path_template) do
      "/pacts/provider/:provider_name/consumer/:consumer_name/webhooks/status"
    end

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Triggered webhook logs" do
    let(:path_template) { "/triggered-webhooks/:trigger_uuid/logs" }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhooks" do
    let(:path_template) { "/webhooks" }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhook" do
    let(:path_template) { "/webhooks/:uuid" }
    let(:custom_parameter_values) { { uuid: webhook_uuid } }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Logs of triggered webhook for webhook" do
    let(:path_template) { "/triggered-webhooks/:uuid/logs" }
    let(:custom_parameter_values) { { uuid: triggered_webhook_uuid } }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhooks for consumer" do
    let(:path_template) { "/webhooks/consumer/:consumer_name" }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhooks for a provider" do
    let(:path_template) { "/webhooks/provider/:provider_name" }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Webhooks for consumer and provider" do
    let(:path_template) { "/webhooks/provider/:provider_name/consumer/:consumer_name" }

    include_examples "supports GET"
    include_examples "supports OPTIONS"
  end

  describe "Executing a saved webhook" do
    let(:path_template) { "/webhooks/:uuid/execute" }

    include_examples "supports OPTIONS"
    include_examples "supports POST"
  end

  describe "Executing an unsaved webhook" do
    let(:path_template) { "/webhooks/execute" }

    include_examples "supports OPTIONS"

    describe "POST" do
      before do
        stub_request(:post, /http/).to_return(:status => 200)
        Timecop.freeze(Time.new(2021, 9, 1, 10, 7, 21))
        allow(PactBroker.configuration).to receive(:webhook_host_whitelist).and_return([/.*/])
      end

      after do
        Timecop.return
      end

      let(:http_params) do
        {
          "events" => [{
            "name" => "contract_content_changed"
          }],
          "request" =>{
            "method" =>"POST",
            "url" =>"https://postman-echo.com/post",
            "username" =>"username",
            "password" =>"password",
            "headers" =>{
              "Accept" =>"application/json"
            },
            "body" => {
              "a" =>"body"
            }
          }
        }.to_json
      end
      include_examples "supports POST"
    end
  end
end
