#!/bin/bash
########## GLOBAL VARS #######
DOMAIN='http://localhost:8080'
ENDPOINT='api/articles'
HEADER='Content-Type: application/json'


########## INSERT ############
JSON_DATA='{"title":"Title New","description":"Description New","status":"1"}'
for i in {1..100}
do
    curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html
done

########## UPDATE ############
JSON_DATA='{"idArticle": 19, "title":"Title Update","description":"Description Update","status":"1"}'
ENDPOINT='api/articles/19'
curl --data "$JSON_DATA" -H "$HEADER" -X PUT "$DOMAIN/$ENDPOINT" > curl-output.html

########## DELETE ############
ENDPOINT='api/articles/29'
curl -X DELETE "$DOMAIN/$ENDPOINT" > curl-output.html
