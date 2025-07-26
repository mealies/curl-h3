version = "8.15.0"

test:
	docker run -t mealies/curl-h3:$(version) curl --version | grep $(version)
#	docker run --rm mealies/curl-h3:$(version) curl -sIL https://http-me.fastly.dev/brotli | grep -i 'content-encoding: br'
	docker run --rm mealies/curl-h3:$(version) curl -sIL https://www.drewbell.net --http3 -H 'user-agent: mozilla' | grep 'HTTP/3'
	docker run  --rm mealies/curl-h3:$(version) httpstat -I -L  https://www.drewbell.net/
build:
	docker build -t mealies/curl-h3:$(version) .