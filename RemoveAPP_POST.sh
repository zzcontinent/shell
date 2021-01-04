#!/bin/bash
[ $1 ] || (echo 'input AppName!' && exit 1)
curl -X POST \
  http://127.0.0.1:9000/api/RemoveAPP \
  -H 'Content-Type: application/json' \
  -d "{
	\"AppName\":\"$1\"
}"
