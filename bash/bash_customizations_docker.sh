#!/bin/bash

__docker_machines_autocomplete=$(docker-machine ls -q)

function docker-get-ipaddress {
    local container_id="$1"
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container_id}
}

alias docker-env="env | grep DOCKER_"
alias d=docker
alias dm=docker-machine
alias dc=docker-compose

# docker-machine create --driver virtualbox guestbook-dev
complete -W "${__docker_machines_autocomplete}" docker-env-set
function docker-env-set {
    local __env="$1"
    eval "$(docker-machine env ${__env})"
    docker-env
}

__docker_image_names="$(docker ps -a | awk '{ print $2 }'  | tail -n +2 | sort -u)"

complete -W "${__docker_image_names}" docker-containers-by-image-name
function docker-containers-by-image-name {
    local _image_name="$1"
    local _container_ids=$(docker ps -a | awk '{ if ($2 == "'${_image_name}'") print $1 }')
    echo ${_container_ids}
}

complete -W "${__docker_image_names}" docker-rm-containers-by-image-name
function docker-rm-containers-by-image-name {
    local _image_name="$1"
    if [[ "${_image_name}" ]]; then
        local _container_ids=$(docker-containers-by-image-name "${_image_name}")
        docker rm ${_container_ids}
        echo "Probably removed: ${_container_ids}"
    else
        echo $__docker_image_names
    fi
}

# remove docker images
# docker rmi $name
function docker-rm-untagged-images {
    docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
}

