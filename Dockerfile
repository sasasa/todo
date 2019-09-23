FROM ruby:2.6.3

# RUN apt-get update -qq && apt-get install -y sudo

# nodeのバージョンが6以上であればなんでも良いと思う
RUN curl -SL https://deb.nodesource.com/setup_10.x | bash

# 最新のyarnを取得
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# 最新のchromeを取得
# RUN curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client nodejs yarn sqlite3 libsqlite3-dev imagemagick
# zip unzip sudo google-chrome-stable

# RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/77.0.3865.40/chromedriver_linux64.zip
# RUN sudo unzip -o /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
# RUN sudo chmod +x /usr/local/bin/chromedriver;

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp


# Gemfile
# source 'https://rubygems.org'



# docker-machine ip default
# 192.168.99.100
# docker-compose run web rails _5.2.3_ new . --force --database=postgresql --skip-test --skip-turbolinks --skip-bundle
# docker-compose build

# vim config/database.yml
# host: db
# username: postgres
# password:

# docker-machine ssh default
# docker volume ls
# /var/lib/docker/volumes

# docker-compose run web bundle install
# docker-compose run web rails db:create RAILS_ENV=development
# docker-compose run web rails db:migrate
# docker-compose run web rails db:migrate RAILS_ENV=test
# docker-compose run web bin/rspec

# docker-compose up -d

# docker-compose exec web bash

# 192.168.99.100:3000

# docker-compose ps

# docker-compose stop↓
# docker-compose run web rails db:migrate:reset
# docker-compose start↑

# docker-compose down -v

