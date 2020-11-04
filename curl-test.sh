#!/bin/bash
curl -d '{"title":"Title New","description":"Description New","status":1}' -H "Content-Type: application/json" -X POST http://localhost:8080/api/articles > debug.html