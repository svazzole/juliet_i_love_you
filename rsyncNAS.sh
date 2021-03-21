#!/bin/sh

if ! type figlet > /dev/null
then
    echo "rsync NAS"
else 
    command figlet "rsync NAS"
fi

# Change all the variables with <...>
NAS="<default_nas_name>"
DIRECTORY="<directory>"
USER="<user>"
DIRECTION="pull"

for arg in "$@"
do
    case $arg in
        push) DIRECTION="push" 
        shift ;;
        pull) DIRECTION="pull" 
        shift ;;
        -n|--nas) NAS=$2 
        shift 
        shift ;;
        -d|--directory) DIRECTORY=$2 
        shift
        shift ;;
        -u|--user) USER=$2
        shift
        shift ;;
    esac
done

case $NAS in
    "<nas1_name>") IP="<ip_nas1>"
                NAS_DIR="<nas1_base_dir>/${USER}/${DIRECTORY}" ;;
    "<nas2_name>") IP="<ip_nas2>"
              NAS_DIR="<nas2_base_dir>${USER}/${DIRECTORY}" ;;
    *) IP="not a valid NAS name" ;;
esac

echo
echo "Destination NAS: $NAS"
echo "Destination IP: $IP"
echo "Local DIRECTORY: $DIRECTORY"
echo "NAS DIRECTORY: $NAS_DIR"

# Change <ssh_port> to the right number
case $DIRECTION in
    "pull") echo "Direction: $DIRECTION"
            COMMAND="-e \"ssh -p <ssh_port>\" ${USER}@${IP}:${NAS_DIR} /home/${USER}/" ;;
    "push") echo "Direction: $DIRECTION"
            COMMAND="-e \"ssh -p <ssh_port>\" /home/${USER}/${DIRECTORY}/ ${USER}@${IP}:${NAS_DIR}" ;;
esac


echo
echo "Running..."
echo

eval rsync -azv \
     --delete --exclude {'venv*/'} \
     $COMMAND
