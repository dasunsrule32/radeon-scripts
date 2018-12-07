#
# Script to set AMD Vega card fan curves.
#
#  authored-by: Aaron Echols
#        email: atechols at gmail dot com
#
#  NOTES:
#
#  This script has been released under the GNU GENERAL PUBLIC LICENSE.
#  Please contribute to the upstream author at:
#  https://github.com/dasunsrule32/radeon-scripts
#

# Variables:
# ----------
DEBUG=0
SYSPATH=`find /sys/devices -name fan1_target 2>/dev/null | sed 's|/fan1_target||g' |head -n1`
AMDGPUPMINFO=/sys/kernel/debug/dri/0/amdgpu_pm_info

# Functions:
# ----------
# Echo a string value that is passed
echo_text() {
   echo >&2 "$@";
}

# Restore default PWM settings on exit:
pwm_default() {
   echo_text "Restoring PWM defaults"
   echo "2" > "$SYSPATH/pwm1_enable"
   if [ $DEBUG = 1 ]; then
      cat $SYSPATH/pwm1_enable
   fi
}

# Main body:
# ----------
# Set PWM to manual control:
echo "1" > "$SYSPATH/pwm1_enable"

# On exit set default fan controls:
trap "pwm_default" EXIT 
if [ $DEBUG = 1 ]; then
   echo_text "Hit ctrl-c to exit..."
fi

while :
do
   # Get GPU temperatures:
   GPUTEMP=`cat $AMDGPUPMINFO|grep "GPU Temperature"|awk '{print $3}'`

   # Set RPM based on temperature range:
   case $GPUTEMP in
      3[0-9]) FANRPM=1000 ;;
      4[0-9]) FANRPM=1200 ;;
      5[0-9]) FANRPM=1700 ;;
      6[0-9]) FANRPM=2200 ;;
      7[0-9]) FANRPM=2700 ;;
      8[0-6]) FANRPM=3000 ;;
           *) FANRPM=3300 ;;
   esac

   # Set the RPM in the sys device for AMD fancontrol:
   echo "$FANRPM" > "$SYSPATH/fan1_target"

   # Wait 3 seconds to re-evaluate temperatures:
   sleep 3s

   # Debug output:
   if [ $DEBUG = 1 ]; then
      echo_text "GPU Temp: $GPUTEMP"
      echo_text " Fan RPM: $FANRPM"
   fi
done
