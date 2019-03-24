FROM ruby:2.5.3-alpine

RUN apk add -u --no-cache openssl --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main && \
    apk add --update tzdata && \
    apk add --no-cache ca-certificates build-base icu-libs postgresql-dev nodejs chromium chromium-chromedriver

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 4

COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
