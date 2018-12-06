#
# Script to set Sapphire RX Vega 64 (Reference) fan curve.
#
#  authored-by: Aaron Echols
#        email: atechols at gmail dot com
#
#  NOTES:
#
#  I've only tested this and currently use it on my current
#  card that I own. I'm sharing since I thought it would be
#  useful for other users. 
#
#  TODO:
#
#   * Fix trap
#   * Add more error checking
#   * Possibly expand further into additional cards
#

# Variables:
# ----------
DEBUG=0
SYSPATH="/sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0/0000:0c:00.0/0000:0d:00.0"
AMDGPUPMINFO=/sys/kernel/debug/dri/0/amdgpu_pm_info

# Functions:
# ----------
# Restore default PWM settings on exit:
pwm_default() {
   echo_text "Restoring PWM defaults"
   echo "2" > "$SYSPATH/hwmon/hwmon0/pwm1_enable"
}

# Echo a string value that is passed
echo_text() {
   echo >&2 "$@";
}

# Main body:
# ----------
# Set PWM to manual control:
echo "1" > "$SYSPATH/hwmon/hwmon0/pwm1_enable"

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
   echo "$FANRPM" > "$SYSPATH/hwmon/hwmon0/fan1_target"

   # Wait 3 seconds to re-evaluate temperatures:
   sleep 3s

   # Debug output:
   if [ $DEBUG = 1 ]; then
      echo_text "GPU Temp: $GPUTEMP"
      echo_text " Fan RPM: $FANRPM"
   fi
done
