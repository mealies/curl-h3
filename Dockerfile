FROM alpine:3.22 AS base

RUN apk add --no-cache \
  autoconf \
  automake \
  brotli-dev \
  build-base \
  cmake \
  git \
  go \
  libpsl-dev \
  libtool \
  linux-headers \
  musl-dev \
  nghttp2-dev \
  pkgconfig \
  wget \
  zlib-dev

WORKDIR /usr/src/app
RUN git clone https://github.com/mealies/httpstat \
    && cd httpstat \
    && go build . \
    && cp httpstat /usr/local/bin \
    && chmod +x /usr/local/bin/httpstat


# https://curl.se/docs/http3.html
# https://github.com/openssl/openssl/releases/tag/openssl-3.5.1
# setting --libdir to make sure its lib for all architectures saves having to set
# RUN cp -r /usr/local/openssl/lib64 /usr/local/openssl/lib 2>/dev/null || :
RUN git clone --depth 1 -b openssl-3.5.1 https://github.com/openssl/openssl \
    && cd openssl \
    && ./config enable-tls1_3 --prefix=/usr/local/openssl --libdir=lib \
    && make \
    && make install


# https://github.com/ngtcp2/nghttp3/releases/tag/v1.11.0
RUN cd .. \
    && git clone --depth 1 -b v1.11.0 https://github.com/ngtcp2/nghttp3 \
    && cd nghttp3 \
    && git submodule update --init \
    && autoreconf -i \
    && ./configure --prefix=/usr/local/nghttp3 --enable-lib-only \
    && make \
    && make install

# https://github.com/curl/curl/releases/tag/curl-8_15_0
RUN cd .. \
    && git clone --depth 1 -b curl-8_15_0 https://github.com/curl/curl \
    && cd curl \
    && autoreconf -fi \
    && export PKG_CONFIG_PATH=/usr/local/openssl/lib/pkgconfig:/usr/local/nghttp3/lib/pkgconfig:/usr/local/ngtcp2/lib/pkgconfig \
    && LDFLAGS="-Wl,-rpath,/usr/local/openssl/lib" ./configure -with-zlib --with-brotli --with-openssl=/usr/local/openssl --with-openssl-quic --with-nghttp3=/usr/local/nghttp3 \
    && make \
    && make install 




FROM alpine:3.22

COPY --from=base /usr/local/bin/httpstat /usr/local/bin/httpstat
COPY --from=base /usr/local/bin/curl /usr/local/bin/curl
COPY --from=base /usr/local/lib/libcurl.so.4 /usr/local/lib/libcurl.so.4
COPY --from=base /usr/local/nghttp3/lib/libnghttp3.so /usr/local/nghttp3/lib/libnghttp3.so.9
COPY --from=base /usr/lib/libnghttp2.so /usr/lib/libnghttp2.so.14
COPY --from=base /usr/lib/libpsl.so.5 /usr/lib/libpsl.so.5
COPY --from=base /usr/lib/libidn2.so.0 /usr/lib/libidn2.so.0
COPY --from=base /usr/lib/libunistring.so.5 /usr/lib/libunistring.so.5
COPY --from=base /usr/local/openssl/lib/libssl.so.3 /usr/local/openssl/lib/libssl.so.3
COPY --from=base /usr/local/openssl/lib/libcrypto.so.3 /usr/local/openssl/lib/libcrypto.so.3
COPY --from=base /usr/lib/libbrotlidec.so.1 /usr/lib/libbrotlidec.so.1
COPY --from=base /usr/lib/libbrotlicommon.so.1 /usr/lib/libbrotlicommon.so.1

USER nobody
RUN env | sort; which curl; curl --version