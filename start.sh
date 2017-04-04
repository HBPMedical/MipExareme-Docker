#!/bin/sh
usage() {
cat <<EOT
usage: $0 [-h|--help] <docker-compose command>
	-h, --help: show this message and exit
	<docker-compose command>:
	- localall: start ExaremeLocal and Raw
	- exalocal: start only ExaremeLocal
	- raw: starts one raw instance
	- distributed: start 2 Exareme workers, a master and 3 raw instances

EOT
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

cd RAW-deploy;
case $1 in
    -h|--help)
    usage
    exit 0
    ;;
    localall)
    shift
    docker stop exaremelocal 1>&- 2>&-
    docker stop raw-engine 1>&- 2>&-
    docker stop raw-ui 1>&- 2>&-
    docker rm exaremelocal 1>&- 2>&-
    docker rm raw-engine 1>&- 2>&-
    docker rm raw-ui 1>&- 2>&-
    ./start.sh unsecured up
    ;;
    exalocal)
    shift
    docker stop exaremelocal 1>&- 2>&-
    docker rm exaremelocal 1>&- 2>&-
    ./start.sh unsecured up exalocal
    ;;
    raw)
    shift
    docker stop raw-engine 1>&- 2>&-
    docker stop raw-ui 1>&- 2>&-
    docker rm raw-engine 1>&- 2>&-
    docker rm raw-ui 1>&- 2>&-
    ./start.sh unsecured up RawUI RawEngine
    ;;
    distributed)
    shift   
    ./vm-destroy.sh;
    ./vm-create.sh;
    ./start.sh swarm n0 create
    ./start.sh swarm n0 start
    ./start.sh swarm n1 create
    ./start.sh swarm n1 start
    ./start.sh swarm n2 create
    ./start.sh swarm n2 start
    ;;
    *)
    usage
    exit 2
    ;;
esac

	

