# Send as bot
Simple readable utility on bash that sends messages like a bot in telegram.  
✅ With `STDIN` Pipe support 🧑‍💻

## Installation
`cp ./tm.sh /usr/local/bin/tm`

## Help
```
tm -h
Usage: tm <MESSAGE>|->
ENVIRONMENT:
  MESSAGE_PREFIX
  CHAT_ID
  API_ID
```

## Usage
- `tm 'test notification'`
- `echo 'test notification' | tm`

## Full code
```bash
# @sha256sum 0xa2dddad7cd05c6e04582fa77e54821cfe7fc342afd01bf2bad4aa24330e7561e
# @eip191signature 0x0ae21e8555f7aa9021bdf5fc8a8445e4f26bc139def7f6099832fa887d679c6e136e9818c7abbae232f89028a23774bcb71a3719b57a07023a6b91c31e51edc71c
MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  API_ID"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
test -f "$SCRIPT_DIR/.env" && . "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && . "$HOME/.config/tm/env"

checkEnv() { name=$1; eval value='$'"$name"; [ -z "$value" ] && name=$(pass show "tm/$name"); printf %s "$value"; }

MESSAGE_PREFIX="$(checkEnv MESSAGE_PREFIX)"
CHAT_ID="$(checkEnv CHAT_ID)"
API_ID="$(checkEnv API_ID)"

urlPrefix="https://api.telegram.org/bot${API_ID}/"
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
```

## License
[![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a [Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

- [LICENSE](https://github.com/andreas-timm/tm/blob/main/LICENSE)
- Author: Andreas Timm
