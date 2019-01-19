# openshift-jr
FROM openshift/base-centos7

LABEL maintainer="Chmouel Boudjnah <chmouel@redhat.com>"
ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="JenkinsFile Runner build" \
      io.k8s.display-name="Builder with JenkinsFile Runner" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,jenkins"


ENV MAVEN_VERSION=3.5.4 \
    JENKINS_VERSION=2.150.2

# Install Maven, Jenkins and add the base-plugin.txt from openshift/jenkins
# images and the install-plugins script, run the install-scripts to install the plugins
RUN INSTALL_PKGS="make tar zip unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel curl" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -L https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p /usr/local/jenkins/uncompressed && \
    curl -L http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war -o /tmp/jenkins.war && \
    unzip /tmp/jenkins.war -d /usr/local/jenkins/uncompressed && \
    rm -f /tmp/jenkins.war && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /opt/s2i/destination && \
    curl -L -s https://raw.githubusercontent.com/openshift/jenkins/master/2/contrib/openshift/base-plugins.txt \
        -o /usr/local/jenkins/base-plugins.txt && \
    curl -L -f -s https://raw.githubusercontent.com/openshift/jenkins/master/2/contrib/jenkins/install-plugins.sh \
        -o /usr/local/jenkins/install-plugins.sh && \
    echo "openshift-pipeline:1.0.52" >> /usr/local/jenkins/base-plugins.txt && \
    echo "permissive-script-security:latest" >> /usr/local/jenkins/base-plugins.txt && \
    cd /usr/local/jenkins && \
    export JENKINS_HOME=$PWD REF=./plugins JENKINS_UC_DOWNLOAD="http://mirrors.jenkins-ci.org" && \
    bash install-plugins.sh base-plugins.txt && \
    rm -f install-plugins.sh base-plugins.txt

WORKDIR /jrbuild
RUN git clone https://github.com/jenkinsci/jenkinsfile-runner && \
    cd jenkinsfile-runner && \
    mvn compile dependency:resolve dependency:resolve-plugins && \
    mvn package

RUN mv /jrbuild/jenkinsfile-runner/app/target/appassembler /usr/local/jenkins/jr && \
    rm -rf /jrbuild && \
    mkdir -p /s2i && \
    chown -R 1001:1001 /s2i /usr/local/jenkins/plugins

WORKDIR /s2i
COPY ./s2i /usr/libexec/s2i

USER 1001
