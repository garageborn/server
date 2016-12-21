FROM debian:jessie

# install dependencies
run echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN apt-get update -qq && apt-get install --fix-missing -y \
  certbot -t jessie-backports \
  locales \
  wget \
  nginx \
  nginx-extras

# setup locale
run echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# copy nginx config
COPY nginx /etc/nginx

# setup geo
WORKDIR /etc/nginx/includes/geoip
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
  gunzip GeoLite2-City.mmdb.gz
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz && \
  gunzip GeoLite2-Country.mmdb.gz

WORKDIR /etc/nginx
