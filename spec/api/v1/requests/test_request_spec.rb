require 'rails_helper'

RSpec.describe 'Test Requests' do
  describe '/api/v1/test' do
    describe 'verifies that real HTTP connections are disabled when running tests' do
      xit 'should absolutely pass or stop what you\'re doing and make sure you didn\'t just actually call a ride from Lyft' do
        expect{ get '/api/v1/test' }.to raise_error(WebMock::NetConnectNotAllowedError)
        expect{ post '/api/v1/test' }.to raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end
end