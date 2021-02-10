package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", HealthCheckHandler)
	http.ListenAndServe(":8080", nil)
	log.Printf("listening on...")
	//log.Fatal(srv.ListenAndServeTLS("server.crt", "server.key"))
}

func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	//io.WriteString(w, `{"alive": true}`)
	io.WriteString(w, `hello`)
}

func HTTP2TestHandler(w http.ResponseWriter, r *http.Request) {
	if pusher, ok := w.(http.Pusher); ok {
		options := &http.PushOptions{
			Header: http.Header{
				"Accept-Encoding": r.Header["Accept-Encoding"],
			},
		}
		if err := pusher.Push("/styles.css", options); err != nil {
			log.Printf("Failed to push: %v", err)
		}
	}
	w.Write([]byte("HTTP2 Test"))
}
