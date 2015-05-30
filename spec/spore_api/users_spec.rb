require 'spec_helper'

describe Spore::Client::Users, :vcr do
  it "should raise an error with invalid credentials" do
    client = Spore::Client.new
    expect { client.login "samsymons", "hunter2" }.to raise_error RuntimeError
    expect(client.signed_in?).to be false
  end

  it "should login with valid credentials" do
    client = Spore::Client.new
    client.login "example@spore.sh", "fakepassword"
    expect(client.signed_in?).to be true
  end

end
