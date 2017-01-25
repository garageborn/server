#!/bin/bash
echo "# nginx"

NGINX_VERSION=1.10.2

packages=(
  # geoip
  libmaxminddb-dev
  libmaxminddb0
  mmdb-bin

  # letsencrypt
  letsencrypt
)
sudo apt-get update && sudo apt-get install -y ${packages[@]}

wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
  tar -zxf nginx-$NGINX_VERSION.tar.gz && \
  git clone https://github.com/leev/ngx_http_geoip2_module.git

cd nginx-$NGINX_VERSION
sudo ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-file-aio \
    --with-http_v2_module \
    --with-ipv6 \
    --add-module=../ngx_http_geoip2_module && \
    sudo make && \
    sudo make install
sudo rm -rf ../nginx-$NGINX_VERSION ../ngx_http_geoip2_module

# setup geo
sudo mkdir -p /etc/geoip && \
  cd /etc/geoip && \
  sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
  sudo gunzip -f GeoLite2-City.mmdb.gz
