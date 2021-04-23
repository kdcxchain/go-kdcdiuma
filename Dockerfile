# Build Gkdc in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-kdcdiuma
RUN cd /go-kdcdiuma && make gkdc

# Pull Gkdc into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-kdcdiuma/build/bin/gkdc /usr/local/bin/

EXPOSE 7264 7265 33960 33960/udp
ENTRYPOINT ["gkdc"]
