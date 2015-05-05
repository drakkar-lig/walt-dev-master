#!/runp/busybox sh

layer_id=$1

# run the command line
runp_work/in/runp_cmdline.sh

# notify end of execution
if [ $? -ne 0 ]
then
    echo END_FAILED
    exit 1
fi

echo
echo END_PRIVILEGED_CMDLINE

# wait until the diff file is ready
read diff_file_ready

# build the diff archive

filtered_diff_files_and_directories()
{
    filtered="$(grep "$1" /runp_work/in/diff_file | awk '{print $2}')"

    if [ "$filtered" != "" ] 
    then
        # with ls -1dp we add a trailing '/' at the end of 
        # directories, which allows to filter them in or out
        # quickly (see following functions)
        echo "$filtered" | xargs ls -1dp
    fi
    
    # note: it is important to check that we have at least one 
    # file otherwise 'ls' will consider the current directory... 
}

filtered_diff_files()
{   # filter directories out
    filtered_diff_files_and_directories "$1" | grep -v "/$" 
}

filtered_diff_directories()
{   # filter directories in
    filtered_diff_files_and_directories "$1" | grep "/$" 
}

cd /

# in the archive we will have:
# - a file containing the layer id this diff was based on
echo $layer_id > layer_id_file
# - a file containing the files and dirs that should be removed
filtered_diff_files_and_directories "^D" > runp_removed
# - the file tree of files and directories that where changed or added
tar cfz /runp_work/out/diff_archive.tar.gz layer_id_file runp_removed \
	$(
	    filtered_diff_directories "^A"
	    filtered_diff_files "^[AC]")

# note: we consider that "changed" directories are directories where some
# files were added or deleted, so we ignore them (since we explicitely
# add these files or register them in /runp_removed).
# 
# (adding these "changed" directories in the archive would cause all the 
# sub-tree they contain to be also added, even if most of this sub-tree was 
# not changed, so we have to avoid this.)
# 
# "Added" directories are included in the archive, of course.
# 
# This approach is an approximation: for example, a "chmod" performed on a
# directory will be ignored.

# notify it
echo
echo ARCHIVE_READY

