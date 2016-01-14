#!/bin/bash

conffile=/etc/dhcp/script.conf
[ -f "${conffile}" ] || exit 1

. "${conffile}"

action="${1}"
target="${2}"
name="${3}"
ip="${4}"

zone="${DOMAIN}"

export KRB5_KTNAME
export KRB5CCNAME

krbinit(){
    klist -l || kinit -k -t "${KRB5_KTNAME}" "${DHCP_PRINCIPAL}"
}

add(){
    samba-tool dns add "${target}" "${zone}" "${name}" A "${ip}" -k yes
}

delete(){
    samba-tool dns delete "${target}" "${zone}" "${name}" A "${ip}" -k yes
}

update(){
    add
    delete
}

krbinit
case "${action}" in
    add)
        add
        ;;
    delete)
        delete
        ;;
    update)
        update
        ;;
esac
