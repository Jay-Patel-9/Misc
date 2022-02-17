#!/bin/bash

file="test-report"

failedlogin=$(grep -i "number of failed logins" $file  | awk -F ':' '{print $2}')
timerange=$(grep -i "Selected time for report" $file | awk -F ':' '{print $2,$3,$4}')
numberofusers=$(grep -i "Number of users:" $file | awk -F ':' '{print $2}' | tr -d ' ')

JSON_STRING=$( jq -n \
                  --arg tp "aureport" \
                  --arg fl "$failedlogin" \
                  --arg tr "$timerange" \
                  --arg nu "$numberofusers" \
                  '{type: $tp ,"Number of Failed Logins": $fl, "Selected time for report": $tr, "Number of users": $nu }' )
                  
echo "${JSON_STRING}"