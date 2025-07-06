package main

// takes a list of websites and check their status concurrently

import (
	"fmt"
	"log"
	"os"
	"sync"
	"net/http"
)

func main() {

	// os.Args[0] is the program name, so we skip it.
	urls := os.Args[1:]

	if len(urls) == 0 {
		fmt.Println("Please provide a list of URLs to check.")
		log.Fatal("No URLs provided")
	}

	// A WaitGroup waits for a collection of goroutines to finish.
	var wg sync.WaitGroup

	// Increment the WaitGroup counter for each URL.
	for _, url := range urls {
		wg.Add(1)

		go func(u string) {
			// Decrement the counter when the goroutine completes.
			defer wg.Done()


			resp, err := http.Get(u)

			if err != nil {
				log.Fatal("Error fetching URL:", u, err)
				fmt.Println("Error fetching URL:", u, err)
				return
			}

			// Don't forget to close the response body.
			defer resp.Body.Close()

			fmt.Printf("Status for %s: [%s]\n", u, resp.Status)

		}(url) // Pass the url as an argument to avoid a common loop variable bug
	}


	// Wait here until all goroutines have called `wg.Done()`
	wg.Wait()

	fmt.Println("All URLs checked successfully.")

}
