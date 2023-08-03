# Send as bot
Simple readable utility on bash that sends messages like a bot in telegram.  

## Features
- `STDIN` pipe support
- Credentials:
    - Environment variables
    - [pass](https://www.passwordstore.org/) (the standard unix password manager)

## Installation
`cp ./tm.sh /usr/local/bin/tm`

## Environment files
- `__SCRIPT_DIR__/.env`
- `$HOME/.config/tm/env`

## Help
```
tm -h
Usage: tm <MESSAGE>|->
ENVIRONMENT:
  MESSAGE_PREFIX
  CHAT_ID
  API_ID
or PASS-NAME: tm/ENVIRONMENT
```

## Usage
- `tm 'test notification'`
- `echo 'test notification' | tm`

## License
[![BSD 3-Clause][bsd-3-clause-shield]][bsd-3-clause]

This source code is licensed under the [3-Clause BSD license][bsd-3-clause].

[bsd-3-clause]: https://opensource.org/licenses/BSD-3-Clause
[bsd-3-clause-shield]: https://img.shields.io/badge/License-BSD_3--Clause-orange.svg

- [LICENSE](https://github.com/andreas-timm/tm/blob/main/LICENSE)
- Author: [Andreas Timm](https://github.com/andreas-timm)
