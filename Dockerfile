FROM    apache/nifi-registry:0.2.0

USER    root

RUN     mkdir -p ${NIFI_REGISTRY_HOME}/ca_trust_anchors
RUN     mkdir -p ${NIFI_REGISTRY_HOME}/flow_storage
RUN     apt update
RUN     apt install -y git
RUN     git init ${NIFI_REGISTRY_HOME}/flow_storage

COPY    ca_trust_anchors/* ${NIFI_REGISTRY_HOME}/ca_trust_anchors/
COPY    scripts/* ${NIFI_REGISTRY_BASE_DIR}/scripts/

RUN     for cert in ${NIFI_REGISTRY_HOME}/ca_trust_anchors/*; do keytool -importcert -trustcacerts -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit -noprompt -alias cert-`shuf -i 0-1000 -n 1` -file ${cert}; done

WORKDIR ${NIFI_REGISTRY_HOME}
