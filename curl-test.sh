#!/bin/bash
########## GLOBAL VARS #######
DOMAIN='http://laravel-api-backend.localhost/'
HEADER='Content-Type: application/json'
ID=$(($RANDOM%100))

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
USER_ID=$(curl -H 'Accept: application/json' -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT" | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w id | cut -d":" -f2 | sed -e 's/^ *//g' -e 's/ *$//g')

########## USER BY ID ###############
ENDPOINT='api/users'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT/$USER_ID" > curl-output.html

########## ALL USERS ################
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT" > curl-output.html

########## INSERT ARTICLE ############
ENDPOINT='api/articles'
JSON_DATA='{"user_id": "'$USER_ID'","title":"Title New","description":"Description New","status":"1"}'
for i in {1..100}
do
    curl --data "$JSON_DATA" -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html
done

########## ALL ARTICLES ###############
ENDPOINT='api/articles'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT" > curl-output.html

###### ALL ARTICLES BY USER ############
ENDPOINT='api/articles/by-user'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT/$USER_ID" > curl-output.html

########## ARTICLES BY ID ##############
ENDPOINT='api/articles'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X GET "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

######### UPDATE ARTICLE ##############
ENDPOINT='api/articles'
JSON_DATA='{"user_id": "'$USER_ID'", "id": '$ID', "title":"Title Update","description":"Description Update","status":"1"}'
curl --data "$JSON_DATA" -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X PUT "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

########## DELETE ARTICLE ############
ENDPOINT='api/articles'
curl -H "Authorization: Bearer ${TOKEN}" -X DELETE "$DOMAIN/$ENDPOINT/$ID" > curl-output.html

######## REFRESH TOKEN ###############
ENDPOINT='api/refresh'
TOKEN=$(curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X POST "$DOMAIN/$ENDPOINT" | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w token | cut -d":" -f2 | sed -e 's/^ *//g' -e 's/ *$//g')
TOKEN=${TOKEN##*|}

############ LOGOUT #################
ENDPOINT='api/logout'
curl -H "$HEADER" -H "Authorization: Bearer ${TOKEN}" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html
