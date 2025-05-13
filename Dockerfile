# Сборочный образ с Go
FROM quay.io/projectquay/golang:1.22 as builder

WORKDIR /
COPY . .
ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -v -o kbot .

# Финальный минимальный образ
FROM scratch
WORKDIR /
COPY --from=builder /kbot /kbot
ENTRYPOINT ["/kbot"]
