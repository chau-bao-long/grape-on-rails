FROM ruby:2.4.1

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && apt-get install -y nodejs && npm install -g gulp-cli bower eslint babel-eslint eslint-plugin-angular
RUN apt-get -y update
RUN apt-get -y install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x xvfb

COPY Gemfile /cache/Gemfile
COPY Gemfile.lock /cache/Gemfile.lock

RUN cd /cache && bundle install


RUN curl -o /usr/bin/framgia-ci https://raw.githubusercontent.com/framgia/ci-report-tool/master/dist/framgia-ci && chmod +x /usr/bin/framgia-ci
