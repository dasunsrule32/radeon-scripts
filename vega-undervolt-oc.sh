#
# Script to Undervolt/Overclock AMD Vega cards.
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
SYSPATH=`find /sys/devices -name pp_od_clk_voltage 2>/dev/null | sed 's|/pp_od_clk_voltage||g' |head -n1`

# Main body:
# ----------
# Undervolt GPU:
echo "manual" > "$SYSPATH/power_dpm_force_performance_level"
echo "s 0 852 800" > "$SYSPATH/pp_od_clk_voltage"
echo "s 1 991 900" > "$SYSPATH/pp_od_clk_voltage"
echo "s 2 1084 910" > "$SYSPATH/pp_od_clk_voltage"
echo "s 3 1138 930" > "$SYSPATH/pp_od_clk_voltage"
echo "s 4 1200 945" > "$SYSPATH/pp_od_clk_voltage"
echo "s 5 1400 955" > "$SYSPATH/pp_od_clk_voltage"
echo "s 6 1500 970" > "$SYSPATH/pp_od_clk_voltage"
echo "s 7 1600 1000" > "$SYSPATH/pp_od_clk_voltage"

# Undervolt Memory:
echo "m 0 167 800" > "$SYSPATH/pp_od_clk_voltage"
echo "m 1 500 850" > "$SYSPATH/pp_od_clk_voltage"
echo "m 2 800 910" > "$SYSPATH/pp_od_clk_voltage"
echo "m 3 1000 1000" > "$SYSPATH/pp_od_clk_voltage"

# Commit changes:
echo "c" > "$SYSPATH/pp_od_clk_voltage"
