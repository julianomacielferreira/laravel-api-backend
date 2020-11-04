#!/bin/bash
DOMAIN='http://localhost:8080'
ENDPOINT='api/articles'
HEADER='Content-Type: application/json'
JSON_DATA='{"title":"Title New","description":"Description New","status":"1"}'
curl --data "$JSON_DATA" -H "$HEADER" -X POST "$DOMAIN/$ENDPOINT" > curl-output.html