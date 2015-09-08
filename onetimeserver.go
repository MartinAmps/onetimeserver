package onetimeserver

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func pidExists(pid int) bool {
	fmt.Printf("checking %d...\n", pid)
	proc, err := os.FindProcess(pid)
	if err != nil {
		log.Printf("%s\n", err)
		return false
	}
	err = proc.Signal(syscall.Signal(0))
	if err != nil {
		log.Printf("%s\n", err)
	}
	return err == nil
}

func WatchServer(ppid int, server Server) {
	channel := make(chan os.Signal, 1)

	signal.Notify(channel, os.Interrupt, os.Kill)
	go func() {
		for true {
			if !pidExists(ppid) || !pidExists(server.Pid()) {
				channel <- os.Kill
			}
			time.Sleep(1 * time.Second)
		}
	}()
	<-channel

	server.Kill()
}