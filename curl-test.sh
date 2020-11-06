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

####### GENERATE RANDON ID ###########
ID=$(($RANDOM%100))

########## UPDATE ARTICLE ############
JSON_DATA='{"idArticle": '$ID', "title":"Title Update","description":"Description Update","status":"1"}'
curl --data "$JSON_DATA" -H "$HEADER" -X PUT "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

########## DELETE ARTICLE ############
ENDPOINT='api/articles'
curl -X DELETE "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

########## REGISTER USER #############
JSON_DATA='{"name": "Juliano Maciel", "email":"ju.maciel.ferreira'$ID'@gmail.com", "password": "password", "password_confirmation": "password"}'
ENDPOINT='api/register'
curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html

########## USER LOGIN ###############
JSON_DATA='{"email":"ju.maciel.ferreira'$ID'@gmail.com", "password": "password"}'
ENDPOINT='api/login'
TOKEN=$(curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w token | cut -d":" -f2 | sed -e 's/^ *//g' -e 's/ *$//g')
TOKEN=${TOKEN##*|}

########## USER PROFILE #############
ENDPOINT='api/profile'
curl -H 'Accept: application/json' -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT" > curl-output.html

########## USER BY ID ###############
ENDPOINT='api/users'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT/1" > curl-output.html

########## ALL USERS ################
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT" > curl-output.html