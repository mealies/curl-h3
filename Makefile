version = "curl 8.11.1"

test:
	podman run -t mealies/curl-h3 curl --version | grep $(version)
	podman run --rm mealies/curl-h3 curl -sIL https://httpbin.org/brotli | grep -i 'content-encoding: br'
	podman run --rm mealies/curl-h3 curl -sIL https://www.drewbell.net --http3 -H 'user-agent: mozilla' | grep 'HTTP/3'

build:
	docker build -t mealies/curl-h3 .