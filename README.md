# GO Telegram bot 

Telegram bot written in GO using [telebot.v4](https://pkg.go.dev/gopkg.in/telebot.v4) and [spf13/cobra](https://github.com/spf13/cobra)

## Telegram Bot  
[t.me/supaduba_bot](https://t.me/supaduba_bot)

## Project structure:
```
.
├── cmd/
│ ├── root.go    # main CLI entry point
│ ├── version.go # version command
│ └── kbot.go    # bot launcher command
├── go.mod
├── main.go
└── README.md
```
## Requirements & Setup 

### 1. Make sure Go is installed
```bash
go version 
```

If not installed, follow the official guide:  
[Link] (https://go.dev/doc/install)

### 2. Clone repo 
```bash 
git clone https://github.com/yourusername/kbot.git
cd kbot
```
### 3. Install all dependecies 
```bash
go mod tidy
```

### 4. Create your Telegram bot using [@BotFather](https://t.me/BotFather) and export the token as an environment variable:
```bash
export TELE_TOKEN=YOUR_TOKEN
```
## CLI commands 

go run . kbot    - run telegram bot 
go run . version - check version of telegram bot
go run . --help  - shows all available commands 

## Example: 
```bash
go run . kbot
```   
Example output: 
```
TelegramBot is running, waiting for messages
👤 andrii_shv: Hello its me
```

### 4. Build the Executable
You can build the project and set version manually via ldflags:

```bash
go build -ldflags "-X="github.com/itopsandrii/kbot/cmd.appVersion=1.0.5
```

### 5. After that you could run telegram bot:
```bash
./kbot kbot
``` 
## Security Note
Never hardcode your `TELE_TOKEN` in the code or commit it to version control. Always use environment variables or a `.env` file.