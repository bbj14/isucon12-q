isuports: test go.mod go.sum *.go cmd/isuports/*
	GOOS=linux GOARCH=amd64 go build -o isuports ./cmd/isuports

test:
	go test -v ./...
