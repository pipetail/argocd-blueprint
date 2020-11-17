FROM registry.access.redhat.com/ubi8
RUN useradd -m app
WORKDIR /home/app
COPY bin/backend app
USER app
CMD ["./app"]
