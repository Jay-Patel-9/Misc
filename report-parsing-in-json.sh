#!/bin/bash

file="test-report"
report_type="aureport"
failedlogin=$(grep -i "number of failed logins" $file  | awk -F ':' '{print $2}')
timerange=$(grep -i "Selected time for report" $file | awk -F ':' '{print $2,$3,$4}')
numberofusers=$(grep -i "Number of users:" $file | awk -F ':' '{print $2}' | tr -d ' ')

JSON_STRING=$( jq -n \
                  --arg type "$report_type" \
                  --arg failedlogin "$failedlogin" \
                  --arg timerange "$timerange" \
                  --arg numberofusers "$numberofusers" \
                  '{Type: $type ,"Number of Failed Logins": $failedlogin, "Selected time for report": $timerange, "Number of users": $numberofusers }' )
                  
echo "${JSON_STRING}"
