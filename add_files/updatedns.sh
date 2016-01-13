#!/bin/bash

action="${1}"
target="${2}"
zone="${3}"
name="${4}"
ip="${5}"

export KRB5_KTNAME=/etc/dhcp.keytab
export KRB5CCNAME=/run/dhcp.krb5cc

krbinit(){
    klist -l
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
