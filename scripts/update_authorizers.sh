#!/bin/sh -e

scripts_dir='/opt/nifi-registry/scripts'

[ -f "${scripts_dir}/common.sh" ] && . "${scripts_dir}/common.sh"


authorizer_providers_file=${NIFI_REGISTRY_HOME}/conf/authorizers.xml
property_xpath="//authorizers/userGroupProvider[./identifier='ldap-user-group-provider']/property"

# Update a given property in the ldap-user-group-provider file if a value is specified
edit_property() {
  property_name=$1
  property_value=$2

  if [ -n "${property_value}" ]; then
    xmlstarlet ed --inplace -u "${property_xpath}[@name='${property_name}']" -v "${property_value}" "${authorizer_providers_file}"
  fi
}


case ${AUTHORIZATION} in
    ldap)
        echo 'Enabling LDAP user authorization'
        sed -i '/To enable the ldap-user-group-provider remove/d' "${authorizer_providers_file}"

        edit_property    "Authentication Strategy"   "${LDAP_AUTHENTICATION_STRATEGY}"
        edit_property    "Manager DN"                "${LDAP_MANAGER_DN}"
        edit_property    "Manager Password"          "${LDAP_MANAGER_PASSWORD}"

        edit_property    "TLS - Keystore"               "${LDAP_TLS_KEYSTORE}"
        edit_property    "TLS - Keystore Password"      "${LDAP_TLS_KEYSTORE_PASSWORD}"
        edit_property    "TLS - Keystore Type"          "${LDAP_TLS_KEYSTORE_TYPE}"
        edit_property    "TLS - Truststore"             "${LDAP_TLS_TRUSTSTORE}"
        edit_property    "TLS - Truststore Password"    "${LDAP_TLS_TRUSTSTORE_PASSWORD}"
        edit_property    "TLS - Truststore Type"        "${LDAP_TLS_TRUSTSTORE_TYPE}"
        edit_property    "TLS - Client Auth"            "${LDAP_TLS_CLIENT_AUTH}"
        edit_property    "TLS - Protocol"               "${LDAP_TLS_PROTOCOL}"

        edit_property    "Url"              "${LDAP_URL}"
        edit_property    "Page Size"        "${LDAP_PAGE_SIZE}"
        edit_property    "Sync Interval"    "${LDAP_SYNC_INTERVAL}"

        edit_property    "User Search Base"             "${LDAP_USER_SEARCH_BASE}"
        edit_property    "User Object Class"            "${LDAP_USER_OBJECT_CLASS}"
        edit_property    "User Search Scope"            "${LDAP_USER_SEARCH_SCOPE}"
        edit_property    "User Search Filter"           "${LDAP_USER_SEARCH_FILTER}"
        edit_property    "User Identity Attribute"      "${LDAP_USER_IDENTITY_ATTRIBUTE}"
        edit_property    "User Group Name Attribute"    "${LDAP_USER_GROUP_NAME_ATTRIBUTE}"
        edit_property    "User Group Name Attribute - Referenced Group Attribute" "${LDAP_USER_GROUP_NAME_ATTRIBUTE_REFERENCE}"

        edit_property    "Group Search Base"        "${LDAP_GROUP_SEARCH_BASE}"
        edit_property    "Group Object Class"       "${LDAP_GROUP_OBJECT_CLASS}"
        edit_property    "Group Search Scope"       "${LDAP_GROUP_SEARCH_SCOPE}"
        edit_property    "Group Search Filter"      "${LDAP_GROUP_SEARCH_FILTER}"
        edit_property    "Group Name Attribute"     "${LDAP_GROUP_NAME_ATTRIBUTE}"
        edit_property    "Group Member Attribute"   "${LDAP_GROUP_MEMBER_ATTRIBUTE}"
        edit_property    "Group Member Attribute - Referenced User Attribute"   ${LDAP_GROUP_MEMBER_ATTRIBUTE_REFERENCE}

        xmlstarlet ed --inplace -u "//authorizers/accessPolicyProvider/property[@name='User Group Provider']" -v "ldap-user-group-provider" "${authorizer_providers_file}"
        ;;
esac