# systemd service install for vega-power-control

      sudo cp vega-power-control /usr/local/bin
      sudo chmod +x /usr/local/bin/vega-power-control
      sudo cp systemd/vega-power-control.service /etc/systemd/system
      sudo systemctl start vega-power-control.service
      sudo systemctl enable vega-power-control.service

You can monitor the service now, by using the following command(s):

      systemctl status vega-power-control.service
      watch -n 5 journalctl -n -b -u vega-power-control.service
      
To enable debug for the above `journalctl` command, do the following:

      sudo vi /usr/local/bin/vega-power-control

Set:

      DEBUG=1
      sudo systemctl start vega-power-control.service

To load in settings, simply:

      sudo systemctl start vega-power-control.service

NOTE: I recommend disabling the service while testing, so a reboot won't
      set bad settings on boot.

      sudo systemctl disable vega-power-control.service
