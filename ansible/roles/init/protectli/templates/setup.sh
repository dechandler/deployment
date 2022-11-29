#!/bin/ash

SETUP_DIR="~{{ login_user.name }}/setup"

ARGS="${@}"
if [ "${ARGS}" == "" ]; then
    ARGS="router,sshd-login,podman,sshd-jump,pihole,updates"
fi

setup_role () {
    cd "${SETUP_DIR}/${1}"
    /bin/ash setup.sh
}

for ROLE in \
    router \
    sshd-login \
    podman \
    sshd-jump \
    updates
do
    echo "$ARGS" | grep -q $ROLE && setup_role $ROLE
done
