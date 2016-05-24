#!/bin/bash

alias denv="env | grep DOCKER_"
alias d=docker
alias dm=docker-machine
alias dc=docker-compose
alias swarm='docker run swarm'

# export MACHINE_STORAGE_PATH=/media/jason/x-dogman-x/docker/machine

alias docker-volumes='docker inspect  -f "{{.Name}} {{.Config.Volumes}}" $(docker ps -a -q)'
# docker inspect  -f "{{.Name}} {{.Config.Volumes}} {{.HostConfig}}" name
alias dc-logs='docker-compose logs -t --tail="all" -f'
alias dm-unset='eval $(docker-machine env --shell /bin/bash -u)'

__docker_machines_autocomplete=$(docker-machine ls -q)

complete -W "$(docker ps | tail -n +2 | awk '{print $NF}')" docker-ip
function docker-ip {
    local container_id="$1"
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container_id}
}


# docker-machine create --driver virtualbox guestbook-dev
complete -W "${__docker_machines_autocomplete}" dm-set
function dm-set {
    local __env="$1"
    local e
    e="$(docker-machine env ${__env})"

    local retval="$?"
    if [[ "$retval" == 0 ]]; then
        eval "$e"
        denv
    fi
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
