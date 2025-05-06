package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "Main",
	Short: "Hello its c CLI tool",
}

var greetCmd = &cobra.Command{
	Use:   "greet",
	Short: "Greetings for user",
	Run: func(cmd *cobra.Command, args []string) {
		name := "Andrii"
		if len(args) > 0 {
			name = args[0]
		}
		fmt.Printf("Hi, %s!\n", name)
	},
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Show version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Version 1.0.0")
	},
}

func CHANGE_FUNC_NAME() {
	rootCmd.AddCommand(greetCmd)
	rootCmd.AddCommand(versionCmd)

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
