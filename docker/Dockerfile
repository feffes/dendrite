FROM golang:1.13-alpine AS build
RUN apk --update --no-cache add openssl bash git ca-certificates
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOBIN=$PWD/bin go install -v ./cmd/...

FROM scratch AS monolith
EXPOSE 8008 8448

# Define default command flag arguments.
ENV DENDRITE_CONFIG_FILE="dendrite.yaml" TLS_CERT_FILE="server.crt" TLS_KEY_FILE="server.key"
WORKDIR /dendrite
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /build/bin/dendrite-monolith-server /bin/monolith
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/monolith"]


FROM scratch AS client-api
EXPOSE 7771
