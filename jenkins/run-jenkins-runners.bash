set -e

export BRANCH_NAME="PR-123"
export BUILD_NUMBER=1

JENKINS_FILE_RUNNER=../tmp/output/jenkinsfileRunner/bin/jenkinsfile-runner
JENKINSFILE_REPO=$GOPATH/src/github.com/nodeshift-starters/nodejs-health-check

oc project
#oc delete all --all

# My heart is bleeding, but does that really cause an issue ?
export JAVA_OPTS="-Dpermissive-script-security.enabled=no_security"

bash ${JENKINS_FILE_RUNNER} -w tmp/uncompressed -p tmp/plugins -f ${JENKINSFILE_REPO}
