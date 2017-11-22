docker build -t auth0-ruby-api-rs256 .
docker run --env-file .env -p 3010:3010 -it auth0-ruby-api-rs256
