# https://developers.redhat.com/blog/2020/03/24/red-hat-universal-base-images-for-docker-users/
FROM registry.access.redhat.com/ubi8
RUN useradd -m app
WORKDIR /home/app
COPY bin/backend app
USER app
CMD ["./app"]
