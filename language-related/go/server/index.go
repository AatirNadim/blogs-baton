package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func requestHandler(writer http.ResponseWriter, req *http.Request) {
	// Log the request
	jobName := req.URL.Query().Get("job")
	if jobName == "" {
		http.Error(writer, "Missing 'job' query parameter", http.StatusBadRequest)
		return
	}

	log.Printf("Request received for job: %s", jobName)

	// --- The Core of Go's Concurrency ---
	// The `go` keyword starts a new goroutine.
	// The main function does NOT wait for it to complete.
	go func() {
		log.Printf("Worker started for job: %s", jobName)
		// Simulate a long-running task like generating a report or processing video.
		time.Sleep(5 * time.Second)
		log.Printf("Worker finished for job: %s", jobName)
	}()

	// Respond to the user immediately.
	// The background job is still running.
	writer.WriteHeader(http.StatusAccepted)
	fmt.Fprintf(writer, "Accepted job '%s'. It will be processed in the background.", jobName)
}

func main() {
	fmt.Println("Starting HTTP server...")

	http.HandleFunc("/process", requestHandler)

	fmt.Println("Registering request handler for /process")
 
	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
	} else {
		log.Println("Server started successfully")
		fmt.Println("Server started successfully")
	}
}