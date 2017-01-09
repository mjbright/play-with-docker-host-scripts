
URL=https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl
FILE=kubectl

downloadURL() {
    URL="$1"; shift
    FILE="$1"; shift

    CMD="curl -O $URL"

    LOOP=0

    echo "$CMD > $FILE"
    set -x
    while ! $CMD > $FILE; do
        let LOOP=LOOP+1
        echo
        echo "[$LOOP]: Trying again ..."
        sleep 0.1
    done
    set +x
}


[ ! -f $FILE ] && {
    downloadURL $URL $FILE
    chmod +x kubectl
    ls -altr kubectl 
}

