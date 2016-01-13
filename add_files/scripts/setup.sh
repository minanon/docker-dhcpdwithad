#!/bin/bash
# @(#) setup dhcpd.conf with getting credentials cache

set -eu

#. /functions.bash
. /home/ymaeda/functions.shell/functions.bash
conffile=/config.conf
conffile=/tmp/config.conf

## get current settings and set default settings
[ -f "${conffile}" ] && . ${conffile}
realm="${REALM:-DOMAIN.TLD}"
domain=""
dhcp_user="${DHCP_USER:-dhcp}"
keytab_file=${KRB5_KTNAME:-/etc/dhcp/dhcp.keytab}
cache_file=${KRB5CCNAME:-/etc/dhcp/dhcp.krb5cc}

question 'realm' 'Please set realm' "${realm}" -r
question 'domain' 'Please set domain' "$( [ -z "${DOMAIN}" ] && to_lower "${realm}" || echo "${DOMAIN}" )" -r
question 'dhcp_user' 'Please set dhcp user name' "${dhcp_user}" -r
question 'keytab_file' 'Please set keytab file path' "${keytab_file}" -r
question 'cache_file' 'Please set credentials cache file path' "${cache_file}" -r


## output config file
#cat <<_CONF
cat <<_CONF >> ${conffile}
REALM=${realm}
DOMAIN=${domain}
DHCP_USER=${dhcp_user}
DHCP_PRINCIPAL=\${DHCP_USER}@\${REALM}
KRB5_KTNAME=${keytab_file}
KRB5CCNAME=${cache_file}
_CONF

. ${conffile}
comp "success setup ${conffile}"

[ -f ${keytab_file} ] && {
    question 'is_create' "Would you like to re-create keytab file?" 'y' 'y' 'n' -i -l
    [ "${is_create}" -eq 'n' ] && exit 0
}

dhcp_principal="${DHCP_PRINCIPAL}"

inf "export keytab to ${keytab_file}"
echo samba-tool domain exportkeytab --principal=${dhcp_principal} ${keytab_file}
samba-tool domain exportkeytab --principal=${dhcp_principal} ${keytab_file}
