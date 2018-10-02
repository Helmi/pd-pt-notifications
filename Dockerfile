# PT-Notifications
#
# build with --build-arg PTN_VERSION=1.2.1 to define the version number to build
#

FROM openjdk:8-jre-alpine

ARG PTN_VERSION

ENV PTN_FILENAME=ptnotifications.rar

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH /usr/local/bin:$PATH
ENV FC_LANG en-US
ENV LC_CTYPE en_US.UTF-8

# install tools
RUN apk add --update wget bash unrar java-cacerts \
  ; ln -sf "${JAVA_HOME}/bin/"* "/usr/bin/"

# fix broken cacerts
RUN rm -f /usr/lib/jvm/default-jvm/jre/lib/security/cacerts \
  ; ln -s /etc/ssl/certs/java/cacerts /usr/lib/jvm/default-jvm/jre/lib/security/cacerts

RUN mkdir -p /pt-notifications

WORKDIR /pt-notifications

RUN wget https://github.com/Roy4lz/ptnotifications/releases/download/${PTN_VERSION}/${PTN_FILENAME}

# unzip the app
RUN unrar e ${PTN_FILENAME} \
  ; rm ${PTN_FILENAME} \
  ; rm settings.properties \
#  ; mkdir config \
#  ; ls -la config/ \
#  ; ln -s ./config/settings.properties . \
  ; chmod +x PTNotifications.jar

# add the application source to the image
COPY start /pt-notifications
RUN chmod +x /pt-notifications/start

# tidy up
RUN rm -rf /tmp/* /var/cache/apk/*

# run it
ENTRYPOINT ["./start"]