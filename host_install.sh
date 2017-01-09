
KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl

MACHINE_PWD_URL=https://github.com/franela/docker-machine-driver-pwd/releases/download/v0.0.2/docker-machine-driver-pwd.tar.gz

#export PWD_SESSION_ID=dc75aca5_node1

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

        # 386, not amd-64??!!
        cp -a linux/386/docker-machine-driver-pwd  /usr/local/bin/docker-machine-driver-pwd 

    }
}

createMachine() {
    NODE="$1"; shift

    CMD="docker-machine create -d pwd $NODE"
    echo $CMD
    $CMD
    eval $(docker-machine env $NODE)
    docker ps
}

downloadKubectl
downloadMachineDriver


echo "Using session id <<$PWD_SESSION_ID>>"
createMachine node1
createMachine node2


