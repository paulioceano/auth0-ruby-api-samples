require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'jwt'
require_relative 'jwt/json_web_token'
require 'dotenv'
require 'rack/cors'

Dotenv.load

SCOPES = {
    '/api/private'    => nil,
    '/api/private-scoped' => ['read:messages']
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
  if SCOPES[request.env['PATH_INFO']] == nil
    true
  else
    # The intersection of the scopes included in the given JWT and the ones in the SCOPES hash needed to access
    # the PATH_INFO, should contain at least one element
    (String(@auth_payload['scope']).split(' ') & (SCOPES[request.env['PATH_INFO']])).any?
  end
end

configure do
  set :bind, '0.0.0.0'
  set :port, '3010'
  set :auth0_domain, ENV['AUTH0_DOMAIN'] || 'testdomain'
  set :auth0_api_audience, ENV['AUTH0_API_AUDIENCE'] || 'testissuer'
end

use Rack::Cors do
  allow do
    origins 'http://localhost:3000'
    resource '*',
             headers: 'Authorization',
             methods: [:get, :post, :options],
             credentials: true
  end
end

get '/api/public' do
  json( message: 'Hello from a public endpoint! You don\'t need to be authenticated to see this.' )
end

get '/api/private' do
  authenticate!
  json( message: 'Hello from a private endpoint! You need to be authenticated to see this.' )
end

get '/api/private-scoped' do
  authenticate!
  json( message: 'Hello from a private endpoint! You need to be authenticated and have a scope of read:messages to see this.' )
end
