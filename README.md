walt-dev-master
===============

This repository allows to build a docker container called waltplatform/dev-master.
This container allows (a) to avoid lengthy setup on each development machine, and
(b) to share development configuration and tools with other development repositories.

(a): specific development tools such as qemu emulation is setup through this container,
and thus not needed on the development machine. As a consequence, the development machine
has almost no specific requirement except docker itself.

(b): once this container is built, running `docker run waltplatform/dev-master env` allows
to output the development configuration (see config.sh) and development tools implemented
as shell functions (see env.sh).

In other development repositories, such as walt-rpi-debian, you will often find on top of a
shell script the following line:
```
eval "$(docker run waltplatform/dev-master env)"
```
This allows to load the development configuration variables and shell functions for use in 
the rest of the script.

After this, you may find instructions such as:
* `enable-cross-arch`
* `docker-preserve-cache`
* etc.

These are some of the shell functions defined in the environment.


Usage
=====

Build the image:
```
$ make
```

Publish on docker hub:
```
$ make publish
```

