
KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl

MACHINE_PWD_URL=https://github.com/franela/docker-machine-driver-pwd/releases/download/v0.0.2/docker-machine-driver-pwd.tar.gz


downloadURL() {
    URL="$1"; shift
    FILE="$1"; shift

#    CMD="curl -O $URL"
    CMD="wget -O $FILE $URL"

    LOOP=0

#    echo "$CMD > $FILE"
#    while ! $CMD > $FILE; do

    echo "$CMD"
    #set -x
    while ! $CMD ; do
        let LOOP=LOOP+1
        echo
        echo "[$LOOP]: Trying again ..."
        sleep 0.1
    done
    #set +x
}

downloadKubectl() {
    FILE=kubectl

    [ ! -f $FILE ] && {
        downloadURL $URL $FILE
        chmod +x kubectl
        ls -altr kubectl 
    }
}

downloadMachineDriver() {
    FILE=docker-machine-driver-pwd.tar.gz

    URL=$MACHINE_PWD_URL

    [ ! -f $FILE ] && {
        downloadURL $URL $FILE
        #chmod +x kubectl
        
        tar ztf $FILE || exit 1
        tar zxf $FILE || exit 1

    }
}



downloadKubectl
downloadMachineDriver



