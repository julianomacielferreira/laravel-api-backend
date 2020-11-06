#!/bin/bash
########## GLOBAL VARS #######
DOMAIN='http://localhost:8080'
ENDPOINT='api/articles'
HEADER='Content-Type: application/json'


########## INSERT ARTICLE ############
JSON_DATA='{"title":"Title New","description":"Description New","status":"1"}'
for i in {1..100}
do
    curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html
done

########## UPDATE ARTICLE ############
JSON_DATA='{"idArticle": 19, "title":"Title Update","description":"Description Update","status":"1"}'
ENDPOINT='api/articles/19'
curl --data "$JSON_DATA" -H "$HEADER" -X PUT "$DOMAIN/$ENDPOINT" > curl-output.html

########## DELETE ARTICLE ############
ID=$(($RANDOM%100))
ENDPOINT='api/articles'
curl -X DELETE "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

########## REGISTER USER #############
JSON_DATA='{"name": "Juliano Maciel", "email":"ju.maciel.ferreira'$ID'@gmail.com", "password": "password", "password_confirmation": "password"}'
ENDPOINT='api/register'
curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html

########## USER LOGIN ###############
JSON_DATA='{"email":"ju.maciel.ferreira'$ID'@gmail.com", "password": "password"}'
ENDPOINT='api/login'
curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html
