require 'minitest/autorun'
require 'minitest/reporters'
require 'json'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def bearer_token(token)
  header 'Authorization', "Bearer #{token}"
end

def last_response_json
  JSON.parse last_response.body
end
