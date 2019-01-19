# openshift-jr
FROM openshift/base-centos7
USER root

LABEL maintainer="Chmouel Boudjnah <chmouel@redhat.com>"
ENV BUILDER_VERSION 1.0

# Install Maven, Wildfly
RUN INSTALL_PKGS="make tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination

WORKDIR /app
COPY . /app

RUN make build

COPY ./s2i/bin/ /usr/libexec/s2i
USER 1001
