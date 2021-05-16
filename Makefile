
all:
	go build ./cmd/gglargs/

run:
	go run ./cmd/gglargs/ -NOUI -D "&" -python xflow "[For complete and up to date information on this command, see the man page by typing 'man xflow']" \
  -d            ""      ""      "[sequencer date]" \
  -exp          ""      ""      "[experiment path]" \
  -noautomsg "0"        "1"   "[value 1 means no auto message display]" \
  -nosubmitpopup "0"        "1"   "[value 1 means no submit popup]" \
  -rc ""        ""      "[maestrorc preferrence file]" \
  -n ""      ""      "[focus on this node at startup]" \
  -l ""      ""      "[loop arguments to node argument]" \
  -debug        "0"     "1"     "[debug message]" \
  ++


test:
	go test ./...

