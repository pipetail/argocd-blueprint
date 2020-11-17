FROM alpine:latest  
RUN apk --no-cache add ca-certificates \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -h /home/app -D app
WORKDIR /home/app
COPY bin/backend app
USER app
CMD ["./app"]