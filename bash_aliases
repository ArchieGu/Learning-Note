
alias ls='/bin/ls -aF --color=auto'
alias lr='ls -alrtF'
alias ports='sudo lsof -iTCP -sTCP:LISTEN -P -n'
alias k='kubectl'
alias ka='kubectl get all --all-namespaces'
alias kc='kubectl create'
alias kd='kubectl delete'
alias kl='kubectl logs -f -n'
alias kvirt='kubectl logs `kubectl get pods | grep -v NAME | awk {'"'"'print $1'"'"'}` -c compute -f'
alias tm='tail -F /var/log/syslog'

function cluster-call {
    export KUBECONFIG=$1
    echo "KUBECONFIG=$KUBECONFIG"
    if [ -z "$2" ]; then
        echo "ERROR: usage: <cluster-kubeconfig.yml> <remote-user>"
    else
        echo "Setting remote user to: $2"
        export k8suser=$2
    fi
}

alias cluster='cluster-call'

function klogs {
    date
    n=$1
    name=$2
    # remove the pod/ prefix if it exists
    name=${name#"pod/"}
    # get full pod name
    name=$(kubectl get pods -n $n | grep $name| awk '{print $1}')
    # tail the logs
    kubectl logs -n $n $name -f
}

function docker-to-wireline-since-ver {
    # ie.  docker-to-writeline-since-ver alpine/socat 1.0.2

    # https://medium.com/@pjbgf/moving-docker-images-from-one-container-registry-to-another-2f1f1631dc49

    if [ -z "$2" ]; then
        echo "usage: <alpine/socat> <version>"
	return 1
    fi

    #original_image="microsoft/dotnet"
    original_image="$1"

    target_acr="gcr.io/wireline-automation/everest"
    minimum_version="$2"
    grep_filter="deps|nanoserver|bionic|latest"

    # Download all images
    docker pull $original_image --all-tags

    # Get all images published after $minimum_version
    # format output to be:
    #   docker tag ORIGINAL_IMAGE_NAME:VERSION TARGET_IMAGE_NAME:VERSION |
    #   docker push TARGET_IMAGE_NAME:VERSION
    # then filter the result, removing any entries containing words defined on $grep_filter (i.e. rc, beta, alpha, etc)
    # finally, execute those as commands
    docker images $original_image \
      --filter "since=$original_image:$minimum_version" \
      --format "docker tag {{.Repository}}:{{.Tag}} $target_acr/{{.Repository}}:{{.Tag}} | docker push $target_acr/{{.Repository}}:{{.Tag}}" | grep -vE $grep_filter | bash

}

function install-krew {

    set -x; cd "$(mktemp -d)" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
    tar zxvf krew.tar.gz &&
    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" &&
    "$KREW" install krew
    set +x
    cd

    if ! grep KREW_ROOT $HOME/.bashrc; then
        echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/.bashrc
        source $HOME/.bashrc
    fi
}

function kssh {

    kubectl run --restart=Never --image=gcr.io/wireline-automation/everest/alpine/socat remote-ssh-pod -- -d -d tcp-listen:9999,fork,reuseaddr tcp-connect:10.42.0.1:22
    kubectl wait --for=condition=Ready pod/remote-ssh-pod
    kubectl port-forward pod/remote-ssh-pod 2222:9999 &
    PF_PID=$!
    sleep 3
    ssh  -o StrictHostKeyChecking=no -p 2222 $k8suser@localhost $@
    kill $PF_PID
    kubectl delete pod/remote-ssh-pod --grace-period 1 --wait=false
}

function kssh-get-logs {
    echo -n Remote sudo password: 
    read -s password
    echo ""

    kubectl run --restart=Never --image=alpine/socat remote-scp-pod -- -d -d tcp-listen:9997,fork,reuseaddr tcp-connect:10.42.0.1:22
    kubectl wait --for=condition=Ready pod/remote-scp-pod
    kubectl port-forward pod/remote-scp-pod 2244:9997 &
    SPF_PID=$!
    sleep 3
    ssh -o StrictHostKeyChecking=no -p 2244 $k8suser@localhost << EOF
    rm rancher2_logs_collector.sh.*
    wget https://raw.githubusercontent.com/rancherlabs/support-tools/master/collection/rancher/v2.x/logs-collector/rancher2_logs_collector.sh
    chmod +x rancher2_logs_collector.sh
    echo $password | sudo -S ./rancher2_logs_collector.sh
    lastfile=\`ls -rt /tmp/\$(hostname)-*.tar.gz | tail -n 1\`
    echo "lastfile: \$lastfile"
    rm rancher-log-collector.tar.gz
    ln -s \$lastfile rancher-log-collector.tar.gz
EOF
    scp  -o StrictHostKeyChecking=no -P 2244 $k8suser@localhost:rancher-log-collector.tar.gz .
    kill $SPF_PID
    kubectl delete pod/remote-scp-pod --grace-period 1 --wait=false
}

function kcpu {
    if [ -z "$1" ]; then
        echo "usage:"
        echo "    kcpu <namespace>"
        return 1
    fi
    kubectl describe pods -n $1 > kcpu.txt
    cat kcpu.txt | grep -i "^Name:\|Requests" -A 1 | grep -v "Namespace\|--\|Requests"
    echo -n "Total requested CPUs: "
    cat kcpu.txt | grep -i "Requests" -A 1 | grep -v "Requests\|--" | awk '{print $2}' | sed 's/m/*0.001/g' | paste -sd+ | bc
}

function kexec {
    kubectl exec -it -n $1 $2 -- $3
}

function tags-docker {
    if [ $# -lt 1 ]; then
        cat << HELP

dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE:
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache

HELP
        return 1
    fi

    image="$1"
    tags=`wget -q https://registry.hub.docker.com/v1/repositories/${image}/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'`

    if [ -n "$2" ]; then
        tags=` echo "${tags}" | grep "$2" `
    fi
    echo "${tags}"
}

function tags-gcloud {
    container=""
    if echo $1 | grep -q "gcr\.io/wireline-automation"; then
       container=$1
    else
       container="gcr.io/wireline-automation/everest/$1"
    fi
    echo "$container"
    gcloud container images list-tags $container
}

function k-remove-evicted-pods {
    kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
}

function k-remove-terminating-pods {
    for np in $(kubectl get pods -A | grep Terminating | awk '{print $1 ":" $2}'); do
	n=$(echo $np | cut -f1 -d':')
	p=$(echo $np | cut -f2 -d':')
        kubectl delete pod -n $n $p --grace-period=0 --force
    done
}

function alpine {
    kubectl run my-alpine-shell --rm -i --tty --image alpine:3.13 -- /bin/sh
    kubectl delete -n default my-alpine-shell
}

function gfind {

	dq='"'
	if [ "$1" ]; then
		if [ "$2" ]; then
			find . -name "$2" -type f -not -path "*.ipynb" -not -path "*.git/*" -not -path "*.svn/*" -not -path "*/html/*" -not -path "*/latex/*" -not -path "*/tags" -exec grep -n -H "$1" {} \;
		else
			#find . -name "*" -type f -not -path "*.svn/*" -exec grep -H "${1}" {} \; -exec file {} \; | grep -v -e "Binary file" -e "ELF 32-bit"
			find . -name "*" -type f -not -path "*.ipynb" -not -path "*.git/*" -not -path "*.svn/*" -not -path "*/html/*" -not -path "*/latex/*" -not -path "*/tags" -not -path "*/node_modules/*" -not -path "*.css" -not -path "*.js" -not -path "*.js.map" -exec grep -n -H "${1}" {} \; | grep -v -e "Binary file" -e "ELF 32-bit"
		fi
	else
		echo "What are you searching for?"
	fi
}

function fci {
	find . -iname "$1" -not -path "*.svn/*"
}

