#!/bin/bash
########## GLOBAL VARS #######
DOMAIN='http://localhost:8080'
ENDPOINT='api/articles'
HEADER='Content-Type: application/json'


########## INSERT ############
JSON_DATA='{"title":"Title New","description":"Description New","status":"1"}'
curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html

########## UPDATE ############
JSON_DATA='{"idArticle": 19, "title":"Title Update","description":"Description Update","status":"1"}'
ENDPOINT='api/articles/19'
curl --data "$JSON_DATA" -H "$HEADER" -X PUT "$DOMAIN/$ENDPOINT" > curl-output.html

########## DELETE ############
ENDPOINT='api/articles/33'
curl -X DELETE "$DOMAIN/$ENDPOINT" > curl-output.html
