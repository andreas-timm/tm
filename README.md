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
# @sha256sum 0x271edb022dd9d4eb1e79daf48aeb4db6f7c003db0c6621e6d500181d50e72036
# @eip191signature 0x9e5ceee582a18e39c3b80f9fc986d0967d2d280eaef020ff5eefccb610db9aed327cd33e849e683b9b72b8681066deadb2f1fbce6acb5280f4386bafa243ca4a1b
MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  API_ID"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
test -f "$SCRIPT_DIR/.env" && source "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && source "$HOME/.config/tm/env"

function checkEnv() { name=$1; [ -z "${!name}" ] && name=$(pass show "tm/$name"); echo -n "${!name}"; }

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
