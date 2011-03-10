#
# Copyright (c) 2010 Linagora
# Patrick Guiran <pguiran@linagora.com>
# http://github.com/Tauop/ScriptHelper
#
# ScriptHelper is free software, you can redistribute it and/or modify
# it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# ScriptHelper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# -f Disable pathname expansion.
# -u Unset variables
set -fu

# Load library ---------------------------------------------------------------
SCRIPT_HELPER_DIRECTORY='..'
[ -r /etc/ScriptHelper.conf ] && . /etc/ScriptHelper.conf

LOAD() {
  if [ -r "${SCRIPT_HELPER_DIRECTORY}/$1" ]; then
    . "${SCRIPT_HELPER_DIRECTORY}/$1"
  else
    echo "[ERROR] Unable to load $1"
    exit 1
  fi
}

LOAD random.lib.sh
LOAD lock.lib.sh
LOAD mutex.lib.sh

# Utility functions ----------------------------------------------------------
TEST_FILE="/tmp/test.$(RANDOM)"
TEST_FILE2="/tmp/test.$(RANDOM)"

# Make tests -----------------------------------------------------------------

for i in `seq 1 6`; do
  echo $i >> "${TEST_FILE2}"
done

pids=

bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 5 ; sleep 8  ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 9 ; echo '1' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 0 ; echo '5' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}'   ; echo '6' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 5 ; echo '2' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 5 ; echo '3' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!" ; sleep 1
bash -c "SCRIPT_HELPER_DIRECTORY=.. source ../mutex.lib.sh; MUTEX_GET '${TEST_FILE}' 5 ; echo '4' >> '${TEST_FILE}' ; MUTEX_RELEASE '${TEST_FILE}'" &
pids="${pids} $!"

wait ${pids}

res=0
diff -au "${TEST_FILE}" "${TEST_FILE2}" >/dev/null || res=1
if [ "${res}" = '1' ]; then
  echo "<<<<<<<<<<<<"
  cat "${TEST_FILE2}"
  echo "============"
  cat "${TEST_FILE}"
  echo ">>>>>>>>>>>>"
fi

[ -f "${TEST_FILE}.mutex"      ] && res=1
[ -f "${TEST_FILE}.mutex.tmp"  ] && res=1
[ -f "${TEST_FILE2}.mutex"     ] && res=1
[ -f "${TEST_FILE2}.mutex.tmp" ] && res=1
 
[ ${res} -eq 0 ] && ( echo ; echo "*** All Tests OK ***" ) || ( echo ; echo "TEST FAILED" )

rm -f "${TEST_FILE}*" "${TEST_FILE2}*"
