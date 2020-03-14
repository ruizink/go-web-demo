package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {

	version := "v2.0.0"

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Serving request: %s", r.URL.Path)
		host, _ := os.Hostname()
		fmt.Fprintf(w, "Go Web Demo %s\n", version)
		fmt.Fprintf(w, "Serving from: %s\n", host)
	})

	http.HandleFunc("/request", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Serving request: %s", r.URL.Path)
		for name, values := range r.Header {
			// Loop over all values for the name.
			for _, value := range values {
				fmt.Fprintf(w, "%s: %s\n", name, value)
			}
		}
	})

	port, ok := os.LookupEnv("PORT")
	if !ok {
		port = "8080"
	}

	log.Printf("Listening on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
