FROM centos:latest

ADD ../tmp/output/jenkinsfileRunner/bin/jenkinsfile-runner /usr/local/jenkins/
ADD tmp/uncompressed /usr/local/jenkins/uncompressed
ADD tmp/plugins /usr/local/jenkins/plugins

ENV JAVA_OPTS="-Dpermissive-script-security.enabled=no_security"

RUN /usr/local/jenkins/jr.sh
