# systemd service install for vega-fan-control

      sudo cp vega-fan-control /usr/local/bin
      sudo chmod +x /usr/local/bin/vega-fan-control
      sudo cp systemd/vega-fan-control.service /etc/systemd/system
      sudo systemctl start vega-fan-control.service
      sudo systemctl enable vega-fan-control.service

You can monitor the service now, by using the following command(s):

      systemctl status vega-fan-control.service
      watch -n 5 journalctl -n -b -u vega-fan-control.service
      
To enable debug for the above `journalctl` command, do the following:

      sudo vi /usr/local/bin/vega-fan-control

Set:

      DEBUG=1
      sudo systemctl start vega-fan-control.service
