#
# Undervolt/OC Sapphire RX Vega 64 (Reference):
#
#  * Reduce temps
#  * Increase performance
#  * Increase longevity of card
#
#  I've set this to some sane defaults that I know work on my card.
#  The cooler isn't the best on the reference card, but these keep
#  the speeds in the 1500Mhz - 1600Mhz range. You may need to tweak
#  your card more get decent performance.
#
#  You can use this script to overclock your card as well. Adjust
#  the p-state clock and voltage to get higher clocks if you'd like.
#  Be forwarned, you can damage your card though. Be judicious with
#  how far you overclock.
#
#  authored-by: Aaron Echols
#        email: atechols at gmail dot com
#
# NOTES:
#
#  * To get live metrics of the card while testing:
#
#    watch -n 1 sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info
#
#  * You need to add the amdgpu.ppfeaturemask on the GRUB_CMDLINE
#    and regenerate the config file:
#
#    amdgpu.ppfeaturemask=0xffffffff
#    sudo update-grub
#
#  * Verify the configuration after reboot, it should match what you used:
#
#    printf "0x%08x\n" $(cat /sys/module/amdgpu/parameters/ppfeaturemask)
#
#  * You can check the currently loaded settings by running the following:
#
#    cat /sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0/0000:0c:00.0/0000:0d:00.0/pp_od_clk_voltage
#
# Command format:
#
#  * echo "[s|m] p-state clock voltage" > "$SYSPATH/pp_od_clk_voltage"
#  * echo "c" > "$SYSPATH/pp_od_clk_voltage" to commit the changes
#  * echo "r" > "$SYSPATH/pp_od_clk_voltage" to restore the default values
#
# TODO:
#
#  * Add error checking
#  * Add additional devices
#

# Variables:
# ----------
DEBUG=0
SYSPATH="/sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0/0000:0c:00.0/0000:0d:00.0"

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
