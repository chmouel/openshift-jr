#!/bin/bash

set -x
set -e
#rm -rf tmp/
mkdir -p ./tmp/

[[ -e tmp/jenkins.war ]] || { echo -n "Getting jenkins.war: ";curl -s -L -f http://mirrors.jenkins.io/war-stable/latest/jenkins.war -o tmp/jenkins.war; echo "done" ;}
echo -n "Getting base-plugin.txt: "
curl -L -f -s https://raw.githubusercontent.com/openshift/jenkins/master/2/contrib/openshift/base-plugins.txt -o tmp/base-plugins.txt
curl -L -f -s https://raw.githubusercontent.com/openshift/jenkins/master/2/contrib/jenkins/install-plugins.sh -o tmp/install-plugins.sh
echo done

# TODO: those are workarounds, see https://github.com/fabric8io/osio-pipeline/issues/95
echo "openshift-pipeline:1.0.52" >> tmp/base-plugins.txt

# TODO: security issue :(
echo "permissive-script-security:latest" >> tmp/base-plugins.txt

export JENKINS_HOME=$PWD/tmp/home
export REF=$PWD/tmp/plugins
export JENKINS_UC_DOWNLOAD="http://mirrors.jenkins-ci.org"

if [[ ! -d tmp/uncompressed ]];then
	mkdir -p tmp/uncompressed
	pushd tmp/uncompressed >/dev/null && {
		unzip ../jenkins.war
	} && popd >/dev/null
fi

bash ./tmp/install-plugins.sh ./tmp/base-plugins.txt
