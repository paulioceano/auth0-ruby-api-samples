FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp

WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler && bundle install --jobs 20 --retry 5
ADD . /myapp

CMD ["ruby", "/myapp/lib/server_rs256.rb"]
EXPOSE 3010
