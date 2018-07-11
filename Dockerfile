FROM golang:1.9

RUN git clone https://github.com/arminc/clair-scanner.git /go/src/clair-scanner

WORKDIR /go/src/clair-scanner

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
		make ensure && \
		make build && \
		ln -s /go/src/clair-scanner/clair-scanner /usr/bin/clair-scanner

RUN apt update -qq && \
		apt install -qq -y\
		apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -qq -y install docker-ce

ENV DOCKER_API_VERSION=1.24
EXPOSE 9279

VOLUME /reports

#ENTRYPOINT ["./clair"]
