FROM ruby:2.1-onbuild

RUN bundle install --path vendor/bundle

CMD rackup --port=9292 --host=0.0.0.0

EXPOSE 9292
