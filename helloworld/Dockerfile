FROM golang:1.17-alpine AS build
WORKDIR /build
ADD go.mod ./
ADD main.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o helloworld

FROM scratch
COPY --from=build /build/helloworld /go/bin/helloworld

ENTRYPOINT [ "/go/bin/helloworld" ]