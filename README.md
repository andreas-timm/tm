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
  ID_AUTH
```

## Usage
- `tm 'test notification'`
- `echo 'test notification' | tm`

## Full code
```bash
MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  ID_AUTH"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
test -f "$SCRIPT_DIR/.env" && source "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && source "$HOME/.config/tm/env"

function checkEnv() { name=$1; [ -z "${!name}" ] && name=$(pass show "tm/$name"); echo -n "${!name}"; }

MESSAGE_PREFIX="$(checkEnv MESSAGE_PREFIX)"
CHAT_ID="$(checkEnv CHAT_ID)"
ID_AUTH="$(checkEnv ID_AUTH)"

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
