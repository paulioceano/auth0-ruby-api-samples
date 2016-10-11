require 'spec_helper'
require 'rack/test'

require 'server_hsa256'
require 'jwt'

describe 'server_hsa256' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def signed_jwt(payload = {}, secret = '')
    default_claims = {
      exp: Time.now.to_i + 3600,
      iss: 'testissuer',
      aud: 'testaudience'
    }
    JWT.encode default_claims.merge(payload), secret, 'HS256'
  end

  it 'should deny access without authorization header' do
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_equal 'Nil JSON web token'
  end

  it 'should deny access if a malformed bearer token is supplied' do
    bearer_token 'badtoken'
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_equal 'Not enough or too many segments'
  end

  it 'should deny access if a bearer token has been signed with the wrong secret' do
    bearer_token signed_jwt({ testpayload: 'testvalue' }, 'wrongsecret' )
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_equal 'Signature verification raised'
  end

  it 'should deny access if the access_token has expired' do
    expiration = Time.now.to_i - 60*60 # 1 hour ago
    bearer_token signed_jwt( exp: expiration,  testpayload: 'testvalue' )
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_equal 'Signature has expired'
  end

  it 'should deny access if the issuer does not match' do
    bearer_token signed_jwt( iss: 'wrongissuer',  testpayload: 'testvalue' )
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_match(/^Invalid issuer/)
  end

  it 'should deny access if the audience does not match' do
    bearer_token signed_jwt( aud: 'wrongaudience',  testpayload: 'testvalue' )
    get '/restricted_resource'
    last_response.status.must_equal 401
    last_response_json['message'].must_match(/^Invalid audience/)
  end

  it 'should allow access if a current applicable access token has been supplied' do
    bearer_token signed_jwt( scope: 'admin read:restricted_resource' )
    get '/restricted_resource'
    last_response.status.must_equal 200
    last_response_json['message'].must_equal 'Access Granted'
    Array(last_response_json['allowed_scopes']).sort.must_equal %w(admin read:restricted_resource)
  end

end
