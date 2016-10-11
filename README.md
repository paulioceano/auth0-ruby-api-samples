# Auth0 API examples for Ruby

## Setup
- Use ruby 2.2+
- Ensure you have `bundler` installed; if not, run `gem install bundler`
- Run `bundle install` from within the sample project root, to install the dependencies

## Running the HSA256 Example

### Setup the resource server (aka API), and a client
*At [manage.auth0.com](https://manage.auth0.com)*
- [Create a new Non-Interactive Client](https://manage.auth0.com/#/applications)
  - Take note of the following:
    - "Domain" (i.e. `yourtenant.auth0.com`)
    - "Client ID" (i.e. `uF7U8A5xroMfAqTu79CiFPM77oyy49ui`)
    - "Client Secret" (i.e. `fEsYJVSIKABIAEq18N1qOATCSLZDT4jjG7GyskH5BdMO89x4zdHiphL0W23UJe1K`)
- [Create a new API](https://manage.auth0.com/#/apis) using `HS256` as the signing algorithm
  - Take note of the following:
    - "Identifier" (specified when you create the API, i.e. `https://mygreatapi.example.com`)
    - "Signing Secret" (i.e. `2nzFyhR7JNNN5UgH09qYpX4KLj5nKhFP`)
- Grant your new client the ability to request access tokens fir your new api by clicking on the "Non Interactive Clients" tab for your API, and toggle "Unauthorized" for your new client to "Authorized"
- _Optional_ If you wish to specify certain scopes to be included in the access token for this client:
  - Create one or more scopes in the "Scopes" tab for your API
  - Under the "Non Interactive Clients" tab for your API, expand the settings for the client (using the arrow to the right of the "Authorized" toggle), and check the scopes you'd like included, and click Save.

### Start your server
In your downloaded sample project folder, run:
```
AUDIENCE=<your API identifier> \
ISSUER=https://<your client domain> \
SIGNING_SECRET=<your API signing secret> \
ruby lib/server_hsa256.rb
```

### Request an access token for your API from Auth0
```
curl --request POST
  --url https://<your client domain>/oauth/token \
  --header 'content-type: application/json' \
  --data '{"client_id":"<your client id>","client_secret":"<your client secret>","audience":"<your api identifier>","grant_type":"client_credentials"}'
```

You will receive a JSON response with an `access_token` value.

### Use your access token to gain entry to your API

```curl --header 'Authorization: Bearer <your access token>' http://localhost:4567/restricted_resource
```
