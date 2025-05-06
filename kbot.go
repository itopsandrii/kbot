package main

import (
	"log"
	"os"
	"time"

	"gopkg.in/telebot.v4"
)

func main() {
	token := os.Getenv("TELE_TOKEN")
	if token == "" {
		log.Fatal("❌ TELE_TOKEN не задана в переменных окружения")
	}

	bot, err := telebot.NewBot(telebot.Settings{
		Token:  token,
		Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
	})
	if err != nil {
		log.Fatal(err)
	}

	bot.Handle("/start", func(c telebot.Context) error {
		return c.Send("HELLO BOOOTTTT!")
	})

	bot.Start()
}
