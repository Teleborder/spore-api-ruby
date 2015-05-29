require 'spec_helper'

describe Spore::Client, :vcr do

  it "can retrieve default options" do
    client = Spore::Client.new
    expect(client.api_endpoint).to eq 'https://pod.spore.sh/'
    expect(client.user_agent).to eq "Spore #{Spore::Version.to_s}"
  end

  it "can configure options" do
    client = Spore::Client.new
    client.api_endpoint = "http://github.com/"

    expect(client.api_endpoint).to eq "http://github.com/"
  end

  it "can configure name" do
    client = Spore::Client.new
    client.name = "production"

    expect(client.email).to eq "production"
  end

  it "can configure email" do
    client = Spore::Client.new
    client.email = "test@email.com"

    expect(client.email).to eq "test@email.com"
  end

  it "can configure key" do
    client = Spore::Client.new
    client.key = "key-123-key"

    expect(client.key).to eq "key-123-key"
  end

  it "should raise an error with invalid credentials" do
    client = Spore::Client.new
    expect { client.login "samsymons", "hunter2" }.to raise_error RuntimeError
    expect(client.signed_in?).to be false
  end
end