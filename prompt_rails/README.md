# Prompt Matcher

Rails app where you can search prompts from huggingface.

## Requirements

* Ruby 3.2.2
* postgres
* redis
* elasticsearch v8.10.2
* nodejs
* esbuild
* yarn
* docker - optional

## Setup

### Hybrid mode - app running in host + elastic + dbs via docker containers

1. make local version for .env via `cp .env-local .env`
2. Since elasticsearch v8.10.2 requries https enabled there is additional step to do:
 - start elasticsearch container via `docker compose up es01`
 - check in the logs if the cluster is up and running
 - copy certificate from elasticsearch container ` docker cp prompt_matcher-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt ./ca.crt`
 - stop container
3. install esbuld via `npm install -g esbuild`
4. install yarn via `npm install -g yarn`
5. bundle install
6. yarn install
7. prepare postgres db via `bin/rails db:create`


### Docker version

Note:

Latest version of elasticsearch requires ssl running locally. In the result docker compose setup is quite complex. I have found a good recipe in elastic search [blog post](https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose). In the result initial setup may look like super complex, but it's a new reality :D

1. make local version for .env via `cp .env-example .env`
2. Since elasticsearch v8.10.2 requries ssl enabled there is additional steps to do:
 - start elasticsearch container via `docker compose up es01`
 - check in the logs if the cluster is up and running
 - copy certificate from elasticsearch container ` docker cp prompt_matcher-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt ./ca.crt`
 - stop container
4. build the base image `docker compose build --no-cache app`
5. prepare postgres db:
  - `docker compose run -u rails --rm app /bin/bash`
  - `bin/rails db:create`

## Load prompts from huggingface

### Hybrid mode

- `bin/rails db:migrate`
- `bin/rails db:seed`

### Docker version

- `docker compose run -u rails --rm app /bin/bash`
- `bin/rails db:migrate`
- `bin/rails db:seed`

## Start application

### Hybrid mode

Execute following command: `bin/dev`

### Docker version

Execute following command: `docker compose up app`

Note: I have noticed that sometimes there there is missed folder permission for `tmp/cache`, but it may be releated to my local env.

## Test

Since full docker version is not working properly I would run specs only from host side:

- `RAILS_ENV=test bin/rails db:migrate`
- `bin/rspec`

## Code quality & security

Code quality keeper [standardrb](https://github.com/standardrb/standard)

`bundle exec standardrb`

Security scan via `bundle exec brakeman`

## Deployment ideas

These days I would try following options:

* [Kamal](https://kamal-deploy.org/)
* [fly.io](https://fly.io/docs/rails/)
* [render](https://render.com/docs/deploy-rails)
