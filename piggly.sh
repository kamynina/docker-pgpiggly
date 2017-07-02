#!/usr/bin/env bash
set -e
set -x

DATABASE=
HOST=
PORT=5432
USER="postgres"
PASSWORD=
RESULT="/var/piggly/result"
COMMAND=

function usage() { echo "Usage: $0 -c [trace|report] -h host -d database -p port -u username -w password" 1>&2; exit 1; }

while getopts d:h:p:u:w:c: OPTION
do
  case $OPTION in
    d)
      DATABASE=$OPTARG
      ;;
    h)
      HOST=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    u)
      USER=$OPTARG
      ;;
    w)
      PASSWORD=$OPTARG
      ;;
    c)
      COMMAND=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z $DATABASE ]] || [[ -z $HOST ]] || [[ -z $PORT ]] || [[ -z $USER ]]
then
  usage
  exit 1
fi


ROOT=/piggly

echo "
piggly:
  adapter: postgresql
  database: $DATABASE
  username: $USER
  password: $PASSWORD
  host: $HOST" > "$ROOT/database.yml"

if [ "$COMMAND" = "trace" ]; then
  "$ROOT/bin/piggly" trace \
  -d "$ROOT/database.yml" \
  -o "$RESULT/reports" \
  -c "$RESULT/cache"
elif [ "$COMMAND" = "report" ]; then
  "$ROOT/bin/piggly" report \
    -o "$RESULT/reports" \
    -c "$RESULT/cache" \
    -f "$RESULT/trace.txt"
  "$ROOT/bin/piggly" untrace \
    -d "$ROOT/database.yml" \
    -c "$RESULT/cache"
    echo "OK, view $RESULT/reports/index.html"
else
  usage
  exit 1
fi;

