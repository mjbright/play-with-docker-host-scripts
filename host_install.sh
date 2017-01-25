
INSTALL_KUBECTL=0
KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl

MACHINE_DRIVER_PWD=/usr/local/bin/docker-machine-driver-pwd 
MACHINE_PWD_URL=https://github.com/franela/docker-machine-driver-pwd/releases/download/v0.0.2/docker-machine-driver-pwd.tar.gz

#export PWD_SESSION_ID=dc75aca5_node1

################################################################################
# Functions:

die() {
    echo "$0: die - $*" >&2
    exit 1
}

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

    URL=$KUBECTL_URL

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
        
        tar ztf $FILE || exit 1
        tar zxf $FILE || exit 1

        # 386, not amd-64??!!
        cp -a linux/386/docker-machine-driver-pwd  $MACHINE_DRIVER_PWD

    }
}

createMachine() {
    NODE="$1"; shift

    CMD="docker-machine create -d pwd $NODE"
    echo $CMD
    $CMD
    eval $(docker-machine env --shell ash $NODE)
    docker ps
}

################################################################################
# MAIN:

########################################
# Check session id is set:

[ -z "$PWD_SESSION_ID" ] && die "Set session id from browser url using session.rc,
    . session.rc URL
e.g.
    . session.rc http://play-with-docker.com/p/dc75aca5-3b20-46b2-98a0-973d00ef8797#dc75aca5_node1
"

echo "Using session id <<$PWD_SESSION_ID>>"

########################################
# Process cmd-line args if any:

while [ ! -z "$1" ]; do
    case $1 in
        -k) INSTALL_KUBECTL=1
     
    esac
done

########################################
# Download tools:

[ $INSTALL_KUBECTL -eq 1 ] && downloadKubectl

[ ! -f $MACHINE_DRIVER_PWD ] && downloadMachineDriver

createMachine master1
createMachine worker1


