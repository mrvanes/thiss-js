-include local.mk

VERSION:=1.0.1
NAME:=thiss-js
REGISTRY:=docker.sunet.se

export PATH := node_modules/.bin:$(PATH)

all: standalone

snyk:
	@npm run snyk-protect

start: dev

dev:
	@npm run dev

local:
	@npm run local

clean:
	@rm -rf dist

build: test snyk
	env BASE_URL=$(BASE_URL) COMPONENT_URL=$(COMPONENT_URL) MDQ_URL=$(MDQ_URL) PERSISTENCE_URL=$(PERSISTENCE_URL) SEARCH_URL=$(SEARCH_URL) STORAGE_DOMAIN=$(STORAGE_DOMAIN) LOGLEVEL=$(LOGLEVEL) DEFAULT_CONTEXT=$(DEFAULT_CONTEXT) webpack --config webpack.prod.js

standalone:
	make BASE_URL='$$$${BASE_URL}' COMPONENT_URL='$$$${BASE_URL}/cta/' MDQ_URL='$$$${MDQ_URL}' PERSISTENCE_URL='$$$${BASE_URL}/ps/' SEARCH_URL='$$$${SEARCH_URL}' STORAGE_DOMAIN='$$$${STORAGE_DOMAIN}' LOGLEVEL='$$$${LOGLEVEL}' DEFAULT_CONTEXT='$$$${DEFAULT_CONTEXT}' build

tests:
	@npm run test

cover:
	@npm run cover

setup:
	@npm install

docker: standalone docker_build

docker_build:
	docker build --no-cache=true -t $(NAME):$(VERSION) .

docker_push_sunet:
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	docker push $(REGISTRY)/$(NAME):$(VERSION)

