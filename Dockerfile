FROM alpine:latest

WORKDIR /

ARG BINARY_FILE

COPY ${BINARY_FILE} /kbot

ENTRYPOINT ["/kbot", "kbot"]
