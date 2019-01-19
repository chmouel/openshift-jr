FROM fabric8/java-centos-openjdk8-jdk:latest

RUN make build

ADD tmp/output/jenkinsfileRunner /usr/local/jenkins/jr
ADD jenkins/tmp/uncompressed /usr/local/jenkins/uncompressed
ADD jenkins/tmp/plugins /usr/local/jenkins/plugins
ADD jenkins/jr.sh /usr/local/jenkins/jr.sh

ENV JAVA_OPTS="-Dpermissive-script-security.enabled=no_security"

CMD /usr/local/jenkins/jr.sh
