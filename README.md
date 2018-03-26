### EASY TO START

## CLONE PROJECT
git clone git@git.epam.com:Yaroslav_Nychka/auto-ds-api.git

## BUILD DOCKER
docker build -t auto-ds-api .
docker-compose build auto-ds-api

## RUN DOCKER
docker-compose up

## CREATE DB
docker-compose run web rake db:create

## RUN MIGRATION
docker-compose run web rake db:migrate

###FOR LOCAL DEVELOPING

## Add file .env in root of project
## For begin you have to add in file following variables:
## - AUTO_DS_API_DB_HOST=db
## - AUTO_DS_API_DB_USER=root
## - AUTO_DS_API_DB_PASSWORD=password
## - AUTO_DS_API_DB_BASENAME=auto-ds-api

## Values for variables are defaults. You can change these values as needed, according to your local settings.

### RUBOCOP
## For checking code convention using rubocop.

## RUN RUBOCOP 
rubocop -R

## RUN TESTS

`rake test`

## Errors and solutions

#### Error

Mysql2::Error: Unknown MySQL server host ‘db’ (0)

#### Solution
$ `touch .env` in rails root and add:

AUTO_DS_API_DB_HOST=localhost
AUTO_DS_API_DB_USER=root
AUTO_DS_API_DB_PASSWORD=