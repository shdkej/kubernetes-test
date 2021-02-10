package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
	"time"
)

const LIMIT = 1000

func main() {
	count := 0
	start := time.Now()
	count = test3(count)
	elapsed := time.Since(start)
	fmt.Println(count, elapsed)
}

func test1(count int) int {
	for i := 0; i < LIMIT; i++ {
		if load() == "hello" {
			fmt.Println("success")
			count += 1
		}
	}
	return count
}

func test2(count int) int {
	wg := sync.WaitGroup{}
	wg.Add(1)

	go func() {
		if load() == "hello" {
			fmt.Println("success")
			count += 1
		}
		wg.Done()
	}()
	wg.Wait()
	return count
}

func test3(count int) int {
	wg := sync.WaitGroup{}
	wg.Add(LIMIT)

	for i := 0; i < LIMIT; i++ {
		go func() {
			if load() == "hello" {
				fmt.Println("success")
				count += 1
			}
			wg.Done()
		}()
	}
	wg.Wait()
	return count
}

func load() string {
	res, err := http.Get("http://localhost:8080")
	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	return string(body)
}
