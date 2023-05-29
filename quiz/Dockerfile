FROM ruby:slim-bullseye

WORKDIR /app

COPY . /app

RUN gem install bundler

RUN bundle install

#CMD ["ruby", "runner.rb"]

CMD ["sleep", "infinity"]
