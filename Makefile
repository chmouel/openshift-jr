ERSION=0.1.0-SNAPSHOT
CWP_MAVEN_REPO_PATH=io/jenkins/tools/custom-war-packager/custom-war-packager-cli
CWP_VERSION=1.5
CWP_MAVEN_REPO=https://repo.jenkins-ci.org/releases
CWP_BASE_VERSION=$(CWP_VERSION)

# Just a Makefile for manual testing
.PHONY: all

all: clean build

clean:
	rm -rf tmp jenkins/tmp

.build/cwp-cli-${CWP_VERSION}.jar:
	rm -rf .build
	mkdir -p .build
	wget -O .build/cwp-cli-${CWP_VERSION}.jar \
		$(CWP_MAVEN_REPO)/${CWP_MAVEN_REPO_PATH}/${CWP_BASE_VERSION}/custom-war-packager-cli-${CWP_VERSION}-jar-with-dependencies.jar
	touch .build/cwp-cli-${CWP_VERSION}.jar

build: .build/cwp-cli-${CWP_VERSION}.jar
	java -jar .build/cwp-cli-${CWP_VERSION}.jar \
	-configPath packager-config.yml
