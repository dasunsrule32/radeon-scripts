# radeon-scripts
Scripts to manage various aspects of the AMD line of cards in Linux. These currently only have been tested on the Sapphire Radeon RX Vega 64 (Reference) card.

# vega-undervolt-oc.sh notes

Undervolt/OC Sapphire RX Vega 64 (Reference):

  * Reduce temps
  * Increase performance
  * Increase longevity of card

  I've set this to some sane defaults that I know work on my card.
  The cooler isn't the best on the reference card, but these keep
  the speeds in the 1500Mhz - 1600Mhz range. You may need to tweak
  your card more get decent performance.

  You can use this script to overclock your card as well. Adjust
  the p-state clock and voltage to get higher clocks if you'd like.
  Be forwarned, you can damage your card though. Be judicious with
  how far you overclock.


 NOTES:

  * To get live metrics of the card while testing:

    `watch -n 1 sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info`

  * You need to add the amdgpu.ppfeaturemask on the GRUB_CMDLINE
    and regenerate the config file. Edit the following line in
    Ubuntu:
    
      `/etc/default/grub`
    
    and modify the following line:
    
      `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.ppfeaturemask=0xffffffff"`
      
    with the following argument:
  
      `amdgpu.ppfeaturemask=0xffffffff`
    
    Then run:
    
      `sudo update-grub`

  * Verify the configuration after reboot, it should match what you used:

    `printf "0x%08x\n" $(cat /sys/module/amdgpu/parameters/ppfeaturemask)`

  * You can check the currently loaded settings by running the following:

        SYSPATH=$(find /sys/devices -name pp_od_clk_voltage 2>/dev/null | sed 's|/pp_od_clk_voltage||g' |head -n1)
        cat $SYSPATH/pp_od_clk_voltage
 
 Command format:

  * `echo "[s|m] p-state clock voltage" > "$SYSPATH/pp_od_clk_voltage"`
  * `echo "c" > "$SYSPATH/pp_od_clk_voltage" to commit the changes`
  * `echo "r" > "$SYSPATH/pp_od_clk_voltage" to restore the default values`

 TODO:

  * Add error checking
  * ~~Add additional devices~~

# vega-fan-curve.sh notes

Script to set Sapphire RX Vega 64 (Reference) fan curve.

NOTES:

  To adjust the `FANRPM`, simply edit the following block in the script to the
  desired RPM for each temperature range.
  
     case $GPUTEMP in
      3[0-9]) FANRPM=1000 ;;
      4[0-9]) FANRPM=1200 ;;
      5[0-9]) FANRPM=1700 ;;
      6[0-9]) FANRPM=2200 ;;
      7[0-9]) FANRPM=2700 ;;
      8[0-6]) FANRPM=3000 ;;
           *) FANRPM=3300 ;;
     esac

TODO:

  * Fix trap
  * Add more error checking
  * ~~Possibly expand further into additional cards~~
