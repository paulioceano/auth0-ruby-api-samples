# Ruby Authorization for RS256-Signed Tokens

This sample demonstrates how to protect endpoints in an Ruby API by verifying an incoming JWT access token signed by Auth0. The token must be signed with the RS256 algorithm and must be verified against your Auth0 JSON Web Key Set.

## Getting Started

If you haven't already done so, [sign up](https://auth0.com) for your free Auth0 account and create a new client in the [dashboard](https://manage.auth0.com).

Clone the repo or download it from the Ruby API quickstart page in Auth0's documentation.

## Running the Sample Application

In order to run the example you need to have Ruby installed.

You also need to set the Domain and API Audience for your Rails API as environment variables with the following names respectively: `AUTH0_DOMAIN` and `AUTH0_API_AUDIENCE`.

Rename `.env.example` to `.env` and set the environment variables to match those in your Auth0 API.

````bash
# .env file
AUTH0_DOMAIN="myAuth0Domain"
AUTH0_API_AUDIENCE=myAPIAudience
````
Once you've set these environment variables, run `bundle install` and then `ruby lib/server_rs256.rb`.

Shut it down manually with Ctrl-C.

## Running the Sample With Docker

In order to run the example with docker you need to have `docker` installed.

You also need to set the client credentials as explained [previously](#running-the-sample-application).

Execute in command line `sh exec.sh` to run the Docker in Linux, or `.\exec.ps1` to run the Docker in Windows.

## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple authentication sources](https://docs.auth0.com/identityproviders), either social like **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce, amont others**, or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://docs.auth0.com/mysql-connection-tutorial)**.
* Add support for **[linking different user accounts](https://docs.auth0.com/link-accounts)** with the same user.
* Support for generating signed [Json Web Tokens](https://docs.auth0.com/jwt) to call your APIs and **flow the user identity** securely.
* Analytics of how, when and where users are logging in.
* Pull data from other sources and add it to the user profile, through [JavaScript rules](https://docs.auth0.com/rules).

## Create a free Auth0 account

1. Go to [Auth0](https://auth0.com/signup) and click Sign Up.
2. Use Google, GitHub or Microsoft Account to login.

## Issue Reporting

If you have found a bug or if you have a feature request, please report them at this repository issues section. Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/whitehat) details the procedure for disclosing security issues.

## Author

[Auth0](https://auth0.com)

## License

This project is licensed under the MIT license. See the `LICENSE` file for more info.
