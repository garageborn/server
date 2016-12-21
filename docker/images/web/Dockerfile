FROM debian:jessie

# install dependencies
run echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
RUN apt-get update -qq && apt-get install --fix-missing -y \
  build-essential \
  certbot -t jessie-backports \
  git-core \
  libpcre3 \
  libpcre3-dev \
  libmaxminddb-dev \
  libmaxminddb0 \
  libssl-dev \
  locales \
  mmdb-bin \
  wget

# setup locale
run echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# setup nginx
ENV NGINX_VERSION 1.10.2
RUN useradd --no-create-home nginx
RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
  tar -zxf nginx-$NGINX_VERSION.tar.gz && \
  git clone https://github.com/leev/ngx_http_geoip2_module.git
WORKDIR /nginx-$NGINX_VERSION
RUN ./configure \
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
    --add-module=/ngx_http_geoip2_module && \
    make && \
    make install
RUN rm -rf /nginx-$NGINX_VERSION /ngx_http_geoip2_module
COPY nginx /etc/nginx

# setup geo
WORKDIR /etc/nginx/includes/geoip
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
  gunzip GeoLite2-City.mmdb.gz
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz && \
  gunzip GeoLite2-Country.mmdb.gz

WORKDIR /etc/nginx
CMD 'nginx'
