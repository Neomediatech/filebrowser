ARG VERSION=v2.31.2

FROM alpine:edge AS builder
ARG VERSION
WORKDIR /tmp
RUN wget https://github.com/filebrowser/filebrowser/releases/download/${VERSION}/linux-amd64-filebrowser.tar.gz
RUN tar xvfz linux-amd64-filebrowser.tar.gz 

FROM scratch
ARG VERSION
ENV APP_VERSION=$VERSION \
    SERVICE=filebrowser \
    TZ=Europe/Rome

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$APP_VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/${SERVICE} \
      org.label-schema.maintainer=Neomediatech

WORKDIR /
#RUN apk add --no-cache tzdata
#RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
COPY --from=builder /tmp/filebrowser /usr/local/bin/filebrowser
CMD ["/usr/local/bin/filebrowser", "-r", "/srv/filebrowser/files", "-d", "/srv/filebrowser/db/filebrowser.db", "-b", "/filebrowser", "-a", "0.0.0.0", "-p", "8080"]
