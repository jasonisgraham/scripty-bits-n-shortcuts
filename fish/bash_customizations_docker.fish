#!/usr/bin/fish

alias denv="env | grep DOCKER_"
alias d=docker
alias dm=docker-machine
alias dc=docker-compose
alias swarm='docker run swarm'
alias drun-bash='docker run -it --rm --entrypoint=bash '

function refresh-stuff {
    __docker_machines_autocomplete=$(docker-machine ls -q)

    complete -W "$(docker ps | tail -n +2 | awk '{print $NF}')" docker-ip
    complete -W "${__docker_machines_autocomplete}" dm-set
    __docker_containers=$(docker ps | tail -n +2 | awk '{print $NF}')
    complete -W "${__docker_containers}" d-bash
    complete -W "${__docker_containers}" d-sh

    __docker_image_names="$(docker ps -a | awk '{ print $2 }'  | tail -n +2 | sort -u)"
    complete -W "${__docker_image_names}" docker-containers-by-image-name
    complete -W "${__docker_image_names}" docker-rm-containers-by-image-name
}

refresh-stuff

alias docker-volumes='docker inspect  -f "{{.Name}} {{.Config.Volumes}}" $(docker ps -a -q)'
# docker inspect  -f "{{.Name}} {{.Config.Volumes}} {{.HostConfig}}" name
alias dc-logs='docker-compose logs -t --tail="all" -f'
alias dm-unset='eval $(docker-machine env --shell /bin/bash -u)'

function docker-ip {
    local container_id="$1"
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container_id}
}

# set docker-machine, update autocompletes
function dm-set {
    local __env="$1"
    local __port="$2"

    local e
    e="$(docker-machine env ${__env})"

    local retval="$?"
    if [[ "$retval" == 0 ]]; then
        eval "$e"

        if [[ "$__port" ]]; then
            DOCKER_HOST=$(docker-machine ip $__env):$__port
        fi
        denv
    fi

    refresh-stuff
}

# bash into container
function d-bash {
    local _c="$1"
    docker exec -it $_c bash
}

# sh into container
function d-sh {
    local _c="$1"
    docker exec -it $_c sh
}

function docker-containers-by-image-name {
    local _image_name="$1"
    local _container_ids=$(docker ps -a | awk '{ if ($2 == "'${_image_name}'") print $1 }')
    echo ${_container_ids}
}

function docker-rm-containers-by-image-name
    local _image_name="$1"
    if [[ "${_image_name}" ]]; then
        local _container_ids=$(docker-containers-by-image-name "${_image_name}")
        docker rm ${_container_ids}
        echo "Probably removed: ${_container_ids}"
    else
        echo $__docker_image_names
    fi
end

# remove docker images
function docker-rm-untagged-images
    docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
end

function docker-rm-exited-containers
    docker rm $(docker ps -a | grep Exited | awk '{print $1}')
end

function dm-ssh
    cmd="docker-machine ssh $DOCKER_MACHINE_NAME"
    echo $cmd
    $cmd
end

## to list names + untruncated commands
alias d-cmds=docker inspect -f "{{.Name}} {{.Config.Cmd}}" $(docker ps -q)
alias d-ps=docker ps --no-trunc

# docker run  -e "LS_PIPELINE_PRODUCTION_MODELS_AND_INDEXES=/usr/src/app/data/production_models_and_indexes/09_models" -v /aws:/aws -v /nlp:/nlp  ls-pipeline:latest  runModels /nlp/data/bnym/01_preprocessing/02_output/supply2013-01-16.html.ocr-txt.xmi bnym
# docker cp target/ls-ie-pipeline-0.0.1-SNAPSHOT-jar-with-dependencies.jar pensive_shirley:/usr/src/app/target/.
# docker  run -v /nlp:/nlp -it --entrypoint=bash ls-pipeline:latest -i
