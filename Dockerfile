FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential

# MySQL ruby library dependency
RUN apt-get install -y default-libmysqlclient-dev

# Nokogiri dependencies
RUN apt-get install -y libxml2-dev libxslt1-dev

RUN gem update bundler

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app
RUN bundle install
COPY . /app

# Add a script to be executed every time the container starts.
COPY bin/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server" "-b", "0.0.0.0"]