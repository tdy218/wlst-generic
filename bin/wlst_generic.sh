#!/bin/sh
#Author: tdy218
#E-mail: tdy218@gmail.com
#Version: 1.0

#Parameters specification
#-Dpython.cachedir property parameter default value is under java.io.tmpdir and directory name is wlstTemp<whoami>.
#-Dpython.cachedir.skip property parameter should not be set.
#-Dwlst.debug.init is used to open debug mode.
#-Dwlst.offline.log=disable for cleaning the cfgfwk_*.log and cfgfwk_*.out file(or wlst_*.log, they are all zero-byte).

JAVA_HOME=""

if [ -n "${JAVA_HOME}" ]; then
    if [ -s "${JAVA_HOME}/bin/java" -a -s "${JAVA_HOME}/lib/tools.jar" ]; then
        export PATH=${JAVA_HOME}/bin:${PATH}
       export JDK_CLASSPATH=".:${JAVA_HOME}/lib/tools.jar"
    else
       echo "Cloud not found ${JAVA_HOME}/bin/java and ${JAVA_HOME}/lib/tools.jar"
       echo "The value of JAVA_HOME variable may be incorrect."
       exit 1
    fi
else
    echo "You should set the JAVA_HOME variable first and the jdk version must be 1.7.x or above."
    exit 1
fi

WORKING_DIR="$(dirname $(pwd))"
export JYTHON_HOME="${WORKING_DIR}/jython/2.7.1"
export CLASSPATH="${JDK_CLASSPATH}:${JYTHON_HOME}/jython.jar:${WORKING_DIR}/lib/*"
export PYTHONPATH="${WORKING_DIR}/packages"

WLST_MEM_ARGS="-Xmx512m"
JAVA_OPTIONS="-Djava.security.egd=file:/dev/./urandom \
              -Dbea.home=${WORKING_DIR} \
              -Dprod.props.file=${WORKING_DIR}/lib/property.txt \
              -Dweblogic.home=${WORKING_DIR}/modules \
              -Dweblogic.wlstHome=${WORKING_DIR} \
              -Dwlst.debug.init=false \
              -Dwlst.offline.log=disable \
              -Dpython.home=${JYTHON_HOME} \
              -Dpython.path=${PYTHONPATH}"

eval java ${WLST_MEM_ARGS} ${JAVA_OPTIONS} weblogic.WLST -skipWLSModuleScanning '"$@"'
