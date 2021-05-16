
all:
	go build ./cmd/gglargs/

run:
	go run ./cmd/gglargs/ -NOUI -D "&" -python xflow "[For complete and up to date information on this command, see the man page by typing 'man xflow']" \
  -d            ""      ""      "[sequencer date]" \
  -exp=bonjour      "adsf"          "[experiment path]" \
  -noautomsg "0"        "1"   "[value 1 means no auto message display]" \
  -debug        "0"     "1"     "[debug message]" \

	go run ./cmd/gglargs/ -NOUI -D "&" -python xflow "[For complete and up to date information on this command, see the man page by typing 'man xflow']" \
  -d            ""      ""      "[sequencer date]" \
  -exp=default1         "default2" "default3"       "[experiment path]" \
  -noautomsg= "0"        "1"   "[value 1 means no auto message display]" \
  -l ""      "asdf"      "[loop arguments to node argument]" \
  -debug        "0"     "1"     "[debug message]" \
  ++ asdf asdfa asdfb

test:
	go test ./...

