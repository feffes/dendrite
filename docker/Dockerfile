###########
## Build ##
###########
FROM golang:1.13-alpine AS build
RUN apk --update --no-cache add openssl bash git ca-certificates
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOBIN=$PWD/bin go install -v ./cmd/...

############################################
#------------------------------------------#
#                 SERVICES                 #
#------------------------------------------#
############################################

##############
## Monolith ##
##############
FROM scratch AS monolith
EXPOSE 8008 8448
ENV DENDRITE_CONFIG_FILE="dendrite.yaml" TLS_CERT_FILE="server.crt" TLS_KEY_FILE="server.key"
WORKDIR /dendrite
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /build/bin/dendrite-monolith-server /bin/monolith
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/monolith"]

#################
## Room Server ##
#################
FROM scratch AS room-server
EXPOSE 7770
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-room-server /bin/room-server
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/room-server"]

################
## Client API ##
################
FROM scratch AS client-api
EXPOSE 7771
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-client-api-server /bin/client-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/client-api"]

####################
## Federation API ##
####################
FROM scratch AS federation-api
EXPOSE 7772
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-federation-api-server /bin/federation-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/federation-api"]

##############
## Sync API ##
##############
FROM scratch AS sync-api
EXPOSE 7773
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-sync-api-server /bin/sync-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/sync-api"]

###############
## Media API ##
###############
FROM scratch AS media-api
EXPOSE 7774
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-media-api-server /bin/media-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/media-api"]

######################
## Public Rooms API ##
######################
FROM scratch AS public-rooms-api
EXPOSE 7775
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-public-rooms-api-server /bin/public-rooms-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/public-rooms-api"]

#######################
## Federation Sender ##
#######################
FROM scratch AS federation-sender
EXPOSE 7776
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-federation-sender-server /bin/federation-sender
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/federation-sender"]

#######################
## Appservice Server ##
#######################
FROM scratch AS appservice-server
EXPOSE 7777
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-appservice-server /bin/appservice-server
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/appservice-server"]

###################
## Typing Server ##
###################
FROM scratch AS typing-server
EXPOSE 7778
ENV DENDRITE_CONFIG_FILE="dendrite.yaml"
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-typing-server /bin/typing-server
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/typing-server"]



############################################
#------------------------------------------#
#                  PROXIES                 #
#------------------------------------------#
############################################


######################
## Client API Proxy ##
######################
FROM scratch AS client-api-proxy
EXPOSE 8008
ENV CLIENT_API_SERVER_URL="http://client-api:7771" SYNC_API_SERVER_URL="http://sync-api:7773" MEDIA_API_SERVER_URL="http://media-api:7774" PUBLIC_ROOMS_API_SERVER_URL="http://public-rooms-api:7775"
COPY --from=build /build/bin/client-api-proxy /bin/client-api-proxy
ENTRYPOINT ["/bin/client-api-proxy", "--bind-address=`:8008`"]


##########################
## Federation API Proxy ##
##########################
FROM scratch AS federation-api-proxy
EXPOSE 8008
ENV FEDERATION_API_SERVER_URL="http://federation-api:7772" MEDIA_API_SERVER_URL="http://media-api:7774"
COPY --from=build /build/bin/federation-api-proxy /bin/federation-api-proxy
ENTRYPOINT ["/bin/federation-api-proxy", "--bind-address=`:8008`"]


############################################
#------------------------------------------#
#                   TOOLS                  #
#------------------------------------------#
############################################

#########################
## Create Account Tool ##
#########################
FROM scratch AS create-account-tool
COPY --from=build /build/bin/create-account /bin/create-account
ENTRYPOINT ["/bin/create-account"]

#############################
## Create Room Events Tool ##
#############################
FROM scratch AS create-room-events-tool
COPY --from=build /build/bin/create-room-events /bin/create-room-events
ENTRYPOINT ["/bin/create-room-events"]

########################
## Generate Keys Tool ##
########################
FROM scratch AS generate-keys-tool
COPY --from=build /build/bin/generate-keys /bin/generate-keys
ENTRYPOINT ["/bin/generate-keys"]

####################
## Kafka Producer ##
####################
FROM scratch AS kafka-producer
COPY --from=build /build/bin/kafka-producer /bin/kafka-producer
ENTRYPOINT ["/bin/kafka-producer"]
