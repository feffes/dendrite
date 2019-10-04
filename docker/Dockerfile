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

################
## Client API ##
################
FROM scratch AS client-api
EXPOSE 7771
WORKDIR /dendrite
COPY --from=build /build/bin/dendrite-client-api-server /bin/client-api
COPY --from=build /build/docker/dendrite-docker.yml ./dendrite.yaml
ENTRYPOINT ["/bin/client-api"]

####################
## Federation API ##
####################


##############
## Sync API ##
##############


###############
## Media API ##
###############


######################
## Public Rooms API ##
######################


#######################
## Federation Sender ##
#######################


####################
## Appservice API ##
####################


###################
## Typing Server ##
###################

############################################
#------------------------------------------#
#                  PROXIES                 #
#------------------------------------------#
############################################


######################
## Client API Proxy ##
######################


##########################
## Federation API Proxy ##
##########################

############################################
#------------------------------------------#
#                   TOOLS                  #
#------------------------------------------#
############################################



#########################
## Create Account Tool ##
#########################


#############################
## Create Room Events Tool ##
#############################

########################
## Generate Keys Tool ##
########################

####################
## Kafka Producer ##
####################
