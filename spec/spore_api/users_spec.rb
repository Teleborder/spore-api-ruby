require 'spec_helper'

describe Spore::Client::Users, :vcr do
  it "should raise an error with invalid credentials" do
    client = Spore::Client.new
    expect { client.login "incorrect", "fpassword" }.to raise_error RuntimeError
    expect(client.signed_in?).to be false
  end

  it "should login with valid credentials" do
    client = Spore::Client.new
    client.login "example@spore.sh", "fakepassword2"
    expect(client.signed_in?).to be true
  end

  it "should signup" do
    client = Spore::Client.new
    client.signup "example+2223555@spore.sh", "fakepassword2"
    expect(client.signed_in?).to be true
  end

  it "should verify" do
    client = Spore::Client.new
    client.email = "example+2223555@spore.sh"
    client.key = "66360e6c-b10d-48f5-894c-5890aa61b75d"
    client.verify "uhxjhf0"
    expect(client.instance_variable_get(:@verified)).to be true
  end
end
