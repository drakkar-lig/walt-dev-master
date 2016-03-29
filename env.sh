#!/bin/bash

docker-remove-last-container()
{
	CID=$(docker ps -l -q) # last container
    # be tolerant, it may still be running for 
    # a few milliseconds
    while [ "$(docker ps -q | grep -w $CID)" != "" ]
    do
        echo "waiting for the container to stop..."
        sleep 1
    done
    docker rm $CID
}

docker-commit-and-remove-last-container()
{
	image="$1"
	CID=$(docker ps -l -q) # last container
	docker commit $CID $image
	docker rm $CID	# keep only the image, not the container
}

docker-privileged-run-and-commit()
{
	image="$1"
	# run what is coming from standard input
	docker run -i --privileged "$image" /bin/bash -e -x
    docker-commit-and-remove-last-container $image
}

docker-copy-dir-to-image()
{
    image=$1
    host_path=$2
    image_path=$3
    cd $host_path
    tar cf - . | docker run -i "$image" \
        /bin/bash -c "mkdir -p $image_path; cd $image_path; tar xf -"
    docker-commit-and-remove-last-container $image
}

docker-copy-to-image()
{
    image=$1
    host_path=$2
    image_path=$3
    docker run -i "$image" /bin/bash -c "cat > $image_path" < $host_path
    docker-commit-and-remove-last-container $image
}

get-docker-bin-mapping-opts()
{
    docker_bin=$(which docker)
    volumes=""" $docker_bin
                /var/run/docker.sock
                $(ldd $docker_bin | grep -o "/.*lib.*/.* ") """
    awk_command=$(printf '{print "-v "$1":%s"$1}' "$HOST_FS_PATH")
    echo "$volumes" | awk "$awk_command"
}

dev-master()
{
    docker_opts="--privileged -i"
    # first args starting with '-' are considered as docker options
    # for example, if we run 
    # $ dev-master -t bash
    # the '-t' must be detected as a docker option and treated as such
    # (see the docker command line below).
    while [ $(expr "$1" : "-") -gt 0 ]
    do
        docker_opts="$docker_opts $1"
        shift
    done  
    docker run $docker_opts waltplatform/dev-master $*
}

docker-clean()
{
    # optionaly remove running containers
    running=$(docker ps -q)
    if [ "$running" != "" ] 
    then
        echo "Some containers are running:"
        docker ps
        echo -n "Should we stop them? (y/n) "
        read resp
        if [ "$resp" = "y" ]
        then
            docker stop $(docker ps -q)
        fi
    fi
        
    # remove terminated containers
    containers=$(docker ps -aq)
    if [ "$containers" != "" ] 
    then
        docker rm $containers
    fi

    # remove unnamed images
    images=$(docker images | grep none | awk '{print $3}')
    if [ "$images" != "" ]
    then 
        docker rmi $images
    fi
}

agnostic-compare()
{   # works for files and directories
    diff -rq $1 $2 >/dev/null
}

copy_timestamps()
{
    src_dir=$(dirname $1)
    dst_dir=$(dirname $2)
    cd $src_dir
    find "$(basename $1)" | while read f
    do
        touch -r $f $dst_dir/$f
    done
    cd -
}

docker-preserve-cache()
{
    file="$1"
    cache_dir="$2"

    cache_file="$cache_dir/$(basename "$file")"
    mkdir -p "$cache_dir"

    if [ -e "$cache_file" ]
    then
        if agnostic-compare "$file" "$cache_file"
        then 
            # file same as the one in cache
            # let docker use its cache by
            # restoring timestamps
            copy_timestamps "$cache_file" "$file"
            return # we are all set
        fi
    fi

    # prepare for next time
    rm -rf "$cache_file"
    cp -rp "$file" "$cache_file"
}

docker-remove-image()
{
    img=$(docker images -q waltplatform/$1)
    if test ! -z "$img"
    then 
        docker rmi $img
    fi
}

enable-cross-arch()
{
    dev-master enable-cross-arch
}

