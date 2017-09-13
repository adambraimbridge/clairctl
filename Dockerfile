FROM alpine:3.5

ENV GOPATH=/go
ENV PATH=${GOPATH}/bin:${PATH}
ENV DOCKER_API_VERSION=1.24
ARG DOCKER_VERSION=${DOCKER_VERSION:-latest}
ARG REPO_PATH="github.com/jgsqware/clairctl"

COPY . /clairctl/

RUN apk add --update curl \
 && apk add --virtual build-dependencies go gcc build-base \
 && adduser clairctl -D \
 && mkdir -p /reports \
 && chown -R clairctl:clairctl /reports /tmp \
 && rm -f docker.tgz \
 && mkdir -p $GOPATH/src/${REPO_PATH} \
 && cp -r /clairctl/. $GOPATH/src/${REPO_PATH} \
 && rm -r /clairctl \
 && cd $GOPATH/src/${REPO_PATH} \
 && go install \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* \
 && rm -rf /go/src

CMD clairctl --config /clairctl/clairctl.yaml --log-level Debug scanCluster