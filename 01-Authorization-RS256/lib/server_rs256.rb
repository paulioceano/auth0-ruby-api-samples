require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'jwt'
require_relative 'jwt/json_web_token'

SCOPES = {
  '/restricted_resource' => ['read:messages'],
  '/another_resource'    => ['some:scope', 'some:other_scope']
}

def authenticate!
  # Extract <token> from the 'Bearer <token>' value of the Authorization header
  supplied_token = String(request.env['HTTP_AUTHORIZATION']).slice(7..-1)

  @auth_payload, @auth_header = JsonWebToken.verify(supplied_token)

  halt 403, json(error: 'Forbidden', message: 'Insufficient scope') unless scope_included

rescue JWT::DecodeError => e
  halt 401, json(error: e.class, message: e.message)
end

def scope_included
  # The intersection of the scopes included in the given JWT and the ones in the SCOPES hash needed to access
  # the PATH_INFO, should contain at least one element
  (String(@auth_payload['scope']).split(' ') & (SCOPES[request.env['PATH_INFO']])).any?
end

configure do
  set :auth0_domain,  ENV['AUTH0_DOMAIN'] || 'testdomain'
  set :auth0_api_audience,  ENV['AUTH0_API_AUDIENCE'] || 'testissuer'
end

before do
  authenticate!
end

get '/restricted_resource' do
  json( message: 'Access Granted', allowed_scopes: String(@auth_payload['scope']).split(' ') )
end
