# radeon-scripts
Scripts to manage various aspects of the AMD line of cards in Linux.

# vega-power-control notes

Set AMD Vega clock/voltage/profile settings:

  * Reduce temps
  * Increase performance
  * Increase longevity of card

  I've set this to some sane defaults that I know work on my card
  (Sapphire Radeon RX Vega 64). The cooler isn't the best on the
  reference card, but these settings keep the speeds in the 1500Mhz
  to 1600Mhz range. You may need to tweak your particular card more
  to get decent performance.

  You can use this script to overclock your card as well. Adjust
  the p-state clock and voltage to get higher clocks if you'd like.
  Be forwarned, you can damage your card though. Be judicious with
  how far you overclock.
  
  You can now adjust your POWERCAP for your card. It requires kernel
  4.20+. To enable the feature, simply set `$POWERCAP = 1`. You can
  set the wattage in the example in the main body:
  
      # To set the allowed maximum power consumption of the GPU to e.g. 220 Watts (Default wattage):
      echo 220000000 > "$SYSPATH/$HWMONPATH/power1_cap"
  
  It's currently set the card default, this may need more checks if
  more cards are introduced at a later time.

  Profiles have now been implemented. By default, the script is set
  `auto` and the profile is set to `balanced` (`DEFAULTDPMSTATE` is there for legacy
  support only). This can easily be adjusted by adjusting the values for `DEFAULTDPMSTATE`
  and `DEFAULTDPMPERFLVL`. The different profile options are described in the [docs](https://dri.freedesktop.org/docs/drm/gpu/amdgpu.html#gpu-power-thermal-controls-and-monitoring).

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

        SYSPATH=$(awk '{print}' <<< `find /sys/devices -name power_dpm_force_performance_level -type f -exec dirname {} \;`)
        cat $SYSPATH/pp_od_clk_voltage
 
 Command format:

  * `echo "[s|m] p-state clock voltage" > "$SYSPATH/pp_od_clk_voltage"`
  * `echo "r" > $SYSPATH/pp_od_clk_voltage to restore the default values`
  * `echo "c" > $SYSPATH/pp_od_clk_voltage to commit the changes`

 Install Notes:
 
  * Install Notes for vega-power-control can be found [here](https://github.com/dasunsrule32/radeon-scripts/blob/master/systemd/INSTALL-vega-power-control.md).

# vega-fan-control notes

Script to set AMD card fan curves.

NOTES:

  To adjust the `FANRPM`, simply edit the following block in the script to the
  desired RPM for each temperature range.
  
     if [ "$GPUTEMP" -ge "20" ] && [ "$GPUTEMP" -le "24" ]; then
        FANRPM=400
     elif [ "$GPUTEMP" -ge "25" ] && [ "$GPUTEMP" -le "29" ]; then
        FANRPM=600
     elif [ "$GPUTEMP" -ge "30" ] && [ "$GPUTEMP" -le "34" ]; then
        FANRPM=800
     elif [ "$GPUTEMP" -ge "35" ] && [ "$GPUTEMP" -le "39" ]; then
        FANRPM=1200
     elif [ "$GPUTEMP" -ge "40" ] && [ "$GPUTEMP" -le "44" ]; then
        FANRPM=1600
     elif [ "$GPUTEMP" -ge "44" ] && [ "$GPUTEMP" -le "49" ]; then
        FANRPM=1800
     elif [ "$GPUTEMP" -ge "50" ] && [ "$GPUTEMP" -le "54" ]; then
        FANRPM=2000
     elif [ "$GPUTEMP" -ge "55" ] && [ "$GPUTEMP" -le "59" ]; then
        FANRPM=2200
     elif [ "$GPUTEMP" -ge "60" ] && [ "$GPUTEMP" -le "64" ]; then
        FANRPM=2400
     elif [ "$GPUTEMP" -ge "65" ] && [ "$GPUTEMP" -le "69" ]; then
        FANRPM=2600
     elif [ "$GPUTEMP" -ge "70" ] && [ "$GPUTEMP" -le "74" ]; then
        FANRPM=2800
     elif [ "$GPUTEMP" -ge "75" ] && [ "$GPUTEMP" -le "79" ]; then
        FANRPM=3000
     elif [ "$GPUTEMP" -ge "80" ] && [ "$GPUTEMP" -le "86" ]; then
        FANRPM=3200
     fi
  
  To watch temperatures, simply enable `DEBUG` in the script if running it manually.
  You can also watch the temps via sysfs and use the following command:
  
        SYSPATH=$(awk '{print}' <<< `find /sys/devices -name power_dpm_force_performance_level -type f -exec dirname {} \;`)
        watch -t -n 1 "awk '{print \$1/(1000)}' $SYSPATH/hwmon/hwmon0/temp1_input && cat $SYSPATH/hwmon/hwmon0/fan1_target"

Install Notes:

  * Install Notes for vega-fan-control can be found [here](https://github.com/dasunsrule32/radeon-scripts/blob/master/systemd/INSTALL-vega-fan-control.md).
