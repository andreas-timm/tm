#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
test -f "$SCRIPT_DIR/.env" && source "$SCRIPT_DIR/.env"

MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  ID_AUTH"
    exit 0
fi

urlPrefix="https://api.telegram.org/bot${ID_AUTH}/"
maxMessageLength=$((4096 - ${#MESSAGE_PREFIX}))

(
    printf 'text=%s' "$MESSAGE_PREFIX"

    if [ -t 0 ]; then
        echo "$MESSAGE" | tail -c$maxMessageLength
    else
        cat - | tail -c$maxMessageLength
    fi
)  \
| curl -sXPOST \
    --url "${urlPrefix}sendMessage" \
    -d "chat_id=$CHAT_ID" \
    -d "parse_mode=markdown" \
    --data-binary @- \
>/dev/null
