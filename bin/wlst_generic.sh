#!/bin/sh
#Author: tdy218
#E-mail: tdy218@gmail.com
#Version: 1.1

#Parameters specification
#-Dpython.cachedir property parameter default value is under java.io.tmpdir and directory name is wlstTemp<whoami>.
#-Dpython.cachedir.skip property parameter should not be set.
#-Dwlst.debug.init is used to open debug mode.
#-Dwlst.offline.log=disable for cleaning the cfgfwk_*.log and cfgfwk_*.out file(or wlst_*.log, they are all zero-byte).
#-Dweblogic.security.TrustKeyStore=CustomTrust do not change this parameter default value no mater what trust type is using.
#-Dweblogic.security.CustomTrustKeyStoreFileName=${WORKING_DIR}/lib/cacerts/WLS11gDemoTrust.jks just should be changed when
#you are planning to use a new trust ca file which match with your target weblogic server.

WORKING_DIR="$(dirname $(pwd))"
JAVA_HOME="${WORKING_DIR}/jre"

if [ -n "${JAVA_HOME}" ]; then
    if [ -s "${JAVA_HOME}/bin/java" ]; then
        export PATH=${JAVA_HOME}/bin:${PATH}
    else
        echo "Cloud not found ${JAVA_HOME}/bin/java"
        echo "The value of JAVA_HOME variable may be incorrect."
        exit 1
    fi
else
    echo "You should set the JAVA_HOME variable first and the jdk version must be 1.7.x or above."
    exit 1
fi

export JYTHON_HOME="${WORKING_DIR}/jython"
export CLASSPATH=".:${JYTHON_HOME}/jython.jar:${WORKING_DIR}/lib/*"

#You should set the following three parameters if you want to make a secure t3s connection.
#Should copy root certificate file to ${WORKING_DIR}/security/cacerts and put the absolute path here.
export WLST_SECURE_ROOT_CERTIFICATE="${WORKING_DIR}/security/cacerts/WLS11gDemoTrust.jks"
#Should be set to true if target weblogic server version is 12.1.2 or above.
export WLS_SSL_ENABLE_JSSE="false"
#Should be set to true if target weblogic server version is 12.1.2 or above.
export WLS_SECURITY_ENABLE_JSSE="false"

WLST_COMMON_OPTIONS="-Dwlst.debug.init=false \
                     -Djava.security.egd=file:/dev/./urandom \
                     -Dbea.home=${WORKING_DIR} \
                     -Dprod.props.file=${WORKING_DIR}/lib/property.txt \
                     -Dweblogic.home=${WORKING_DIR} \
                     -Dweblogic.wlstHome=${WORKING_DIR} \
                     -Dwlst.offline.log=disable \
                     -Dpython.home=${JYTHON_HOME}"


WLST_SECURE_OPTIONS="-Dssl.debug=false \
                     -Dweblogic.StdoutDebugEnabled=false \
                     -Dweblogic.nodemanager.sslHostNameVerificationEnabled=false \
                     -Dweblogic.security.SSL.ignoreHostnameVerification=true \
                     -Dweblogic.security.TrustKeyStore=CustomTrust \
                     -Dweblogic.security.CustomTrustKeyStoreType=JKS \
                     -Dweblogic.ssl.JSSEEnabled=${WLS_SSL_ENABLE_JSSE} \
                     -Dweblogic.security.SSL.enableJSSE=${WLS_SECURITY_ENABLE_JSSE} \
                     -Dweblogic.security.CustomTrustKeyStoreFileName=${WLST_SECURE_ROOT_CERTIFICATE}"
                     

eval java -Xmx512m ${WLST_COMMON_OPTIONS} ${WLST_SECURE_OPTIONS} weblogic.WLST -skipWLSModuleScanning '"$@"'
