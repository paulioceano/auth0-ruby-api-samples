require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'jwt'

def authenticate!
  # Extract <token> from the 'Bearer <token>' value of the Authorization header
  supplied_token = String(request.env['HTTP_AUTHORIZATION']).slice(7..-1)

  JWT.decode supplied_token, settings.shared_secret,
    true, # Verify the signature of this token
    algorithm: 'HS256',
    iss: settings.issuer,
    verify_iss: true,
    aud: settings.audience,
    verify_aud: true

rescue JWT::DecodeError => e
  halt 401, json(error: e.class, message: e.message)
end

configure do
  set :shared_secret, ENV['SIGNING_SECRET'] || ''
  set :issuer,  ENV['ISSUER'] || 'testissuer'
  set :audience,  ENV['AUDIENCE'] || 'testaudience'
end

before do
  @auth_payload, @auth_header = authenticate!
end

get '/restricted_resource' do
  json( message: 'Access Granted', allowed_scopes: String(@auth_payload['scope']).split(' ') )
end
