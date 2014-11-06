#!/bin/bash
set -e

get-last-layer-id()
{
    image="$1"
    docker history -q "$image" | head -n 1
}

cmdline-to-cache-name()
{
    echo -n "RUNP"
    echo "$1" | tr -cd '[a-z][A-Z][0-9]'
}

docker-prepare-runp-cache-for-build()
{
    cache_dir="$1"
    echo -n > "$cache_dir/runp_cache_whitelist"
}

docker-clean-old-runp-cache()
{
    cache_dir="$1"
    sort -u "$cache_dir/runp_cache_whitelist" > "$cache_dir/sorted_whitelist"
    cd $cache_dir 
    find $cache_dir -name "RUNP*" | sed -e 's/^..//g' | \
            sort > "$cache_dir/sorted_all"
    rm -f $(
        comm -23 "$cache_dir/sorted_all" "$cache_dir/sorted_whitelist")
}

get-runp-cache-archive-path()
{
    layer_id="$1"
    runp_cmdline="$2"
    cache_dir="$3"

    cache_archive_name=$(cmdline-to-cache-name "$runp_cmdline")
    cache_archive="$cache_dir/$cache_archive_name"
    #echo "$cache_archive_name" >> "$cache_dir/runp_cache_whitelist"
    
    if [ -f "$cache_archive" ]
    then    # cache exists for this command
        layer_id_in_archive=$(tar xfzO "$cache_archive" layer_id_file)
        if [ $layer_id != $layer_id_in_archive ] 
        then    # but the cache was not generated from the same layer!
                # -> it is obsolete
            rm -f "$cache_archive"
        fi
    fi
            
    echo "$cache_archive"
}

generate-cache-archive-loading-code()
{
    archive_name="$1"
    # note: the ADD directive of the Dockerfile automatically
    # detects that our file is an archive, and uncompress it.
    cat << EOF
ADD $archive_name /
RUN cd / && rm -rf \$(cat runp_removed) runp_removed layer_id_file
EOF
}

docker-privileged-build()
{
    image="$1"
    cache_dir="$2"
    mkdir -p "$cache_dir"
    
    #docker-prepare-runp-cache-for-build "$cache_dir"

    if [ ! -d runp ]
    then
        docker run waltplatform/dev-master runp-tools-archive | tar xfz -
    fi
    mkdir -p runp_work/in runp_work/out
    
    mv Dockerfile Dockerfile.work_copy

    touch -r runp dfile

    # build...
    while true
    do
        if [ runp -nt dfile ]; then break; fi
        runp_line_info="$(grep -n "^RUNP" Dockerfile.work_copy | head -n 1)"
        if [ "$runp_line_info" = "" ]
        then
            # no more RUNP lines
            mv Dockerfile.work_copy Dockerfile
            docker build -t "$image" . ; result=$?
            break
        else
            # at least one more RUNP line
            runp_line_num=$(echo "$runp_line_info" | sed -e "s/:.*//")
            # build up to the line preceding this RUNP line
            head -n $((runp_line_num-1)) Dockerfile.work_copy > Dockerfile
            if [ runp -nt dfile ]; then break; fi
            docker build -t "$image" . ; result=$?
            if [ $result -ne 0 ]
            then
                break
            fi
            # retrieve the last layer id of this image
            layer_id=$(get-last-layer-id "$image")
            # get the RUNP cmdline to execute
            runp_cmdline="$(echo "$runp_line_info" | sed -e "s/.*:RUNP[:space:]*//")"
            # compute the cache archive path
            cache_archive=$(get-runp-cache-archive-path "$layer_id" "$runp_cmdline" "$cache_dir")
            # check if a valid cache archive exists
            if [ -f "$cache_archive" ] 
            then    # yes! we will use this cache then
                cp -p "$cache_archive" .
                cache_archive_name=$(basename $cache_archive)
                # we replace the RUNP line of the dockerfile
                # by a set of lines allowing to load the cache archive 
                generate-cache-archive-loading-code $cache_archive_name >> Dockerfile
                # we append the rest of Dockerfile.work_copy
                num_lines=$(cat Dockerfile.work_copy | wc -l)
                tail -n $((num_lines-runp_line_num)) Dockerfile.work_copy >> Dockerfile
                # we now have a new version of Dockerfile.work_copy
                mv Dockerfile Dockerfile.work_copy
                # continue the loop...
            else
                    # no cache archive, let's generate it, so that
                    # on next loop iteration we can use it
                # we have to run the privileged cmdline,
                # when it's done check the differences and
                # compute the cache archive. All this in one
                # docker container.
                # for this we use an expect script.
                cat > runp_work/in/runp_cmdline.sh << EOF
#!/runp/busybox sh
$runp_cmdline
EOF
                chmod +x runp_work/in/runp_cmdline.sh
                runp/run_privileged.exp "$image" "$layer_id"
                result=$? 
                docker-remove-last-container
                if [ $result -ne 0 ]
                then
                    break
                fi
                cp runp_work/out/diff_archive.tar.gz "$cache_archive"
                # continue the loop...
            fi
        fi
    done

    # clean up
    #docker-clean-old-runp-cache "$cache_dir"
    return $result
}

