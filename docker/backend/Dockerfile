FROM alpine:latest  
RUN apk --no-cache add ca-certificates \
    && adduser app
WORKDIR /home/app
COPY bin/backend app
USER app
CMD ["./app"]