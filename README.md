# curl-h3
Container image for Curl with HTTP/3 and Brotli support

## What is this?
Curl with HTTP/3 (using [openssl](https://github.com/openssl/openssl) & [nghttp3](https://github.com/ngtcp2/nghttp3)) and with [Brotli](https://github.com/google/brotli) support

```
docker run --rm mealies/curl-h3:latest curl --version 
```

```
curl 8.15.0-DEV (aarch64-unknown-linux-musl) libcurl/8.15.0-DEV OpenSSL/3.5.1 zlib/1.3.1 brotli/1.1.0 libidn2/2.3.7 libpsl/0.21.5 nghttp2/1.65.0 nghttp3/1.11.0
Release-Date: [unreleased]
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp ws wss
Features: alt-svc AsynchDNS brotli HSTS HTTP2 HTTP3 HTTPS-proxy IDN IPv6 Largefile libz NTLM PSL SSL threadsafe TLS-SRP UnixSockets
```

## How to use this image
```
docker pull mealies/curl-http3:latest

docker run --rm mealies/curl-h3 curl -sIL https://www.drewbell.net -H 'user-agent: mozilla' 
```

### Use --http3 flag to test HTTP/3 
```
docker run --rm mealies/curl-h3 curl --http3 -sI https://www.google.com
```

```
HTTP/3 200
content-type: text/html; charset=ISO-8859-1
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-8rhub7UGx2PLm_2m1eDZQQ' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
accept-ch: Sec-CH-Prefers-Color-Scheme
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Thu, 26 Dec 2024 11:56:57 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Thu, 26 Dec 2024 11:56:57 GMT
cache-control: private
set-cookie: AEC=AZ6Zc-XbKqNBtUr8bzMKMBp_btBtZdav4bBOoKFvPhfPovUzyjkOx8Zd2A; expires=Tue, 24-Jun-2025 11:56:57 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
set-cookie: __Secure-ENID=24.SE=Yvi_gg5awOLFCc21s3JezhOz5MKBCWIVGXTdCnWT9B1F-pZEP7b5i6qbd85w71l_PjfkPxgIX9iFyzvF3bq8-pWSfSNNqMuFsZw9co1dkVH_8H7A7J_oEdRZEO83cmJfTLRMWf6Fh3nFh3d2LUMn7V6Dzc27cm1ct0kW8omunzhghLPQamB-l4aK1Aw97RBOGcrknuyJ; expires=Mon, 26-Jan-2026 04:15:15 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```


### httpstat support

Using go version of [httpstat](https://github.com/mealies/httpstat).  It now supports HTTP/3.

`docker run  --rm mealies/curl-h3 httpstat -h3  https://www.drewbell.net/`

![](httpstat.png?raw=true "HTTPSTAT")
