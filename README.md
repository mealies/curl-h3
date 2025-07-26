# curl-h3
Container image for Curl with HTTP/3 and Brotli support

## What is this?
Curl with HTTP/3 (using [openssl](https://github.com/openssl/openssl) & [nghttp3](https://github.com/ngtcp2/nghttp3)) and with [Brotli](https://github.com/google/brotli) support

```
docker run --rm mealies/curl-h3:latest curl --version 
```
