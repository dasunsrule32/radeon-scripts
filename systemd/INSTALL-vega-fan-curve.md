# systemd service install for vega-fan-control

      sudo cp vega-fan-control /usr/local/bin
      sudo chmod +x /usr/local/bin/vega-fan-control
      sudo cp systemd/vega-fan-curve.service /etc/systemd/system
      sudo systemctl start vega-fan-curve.service
      sudo systemctl enable vega-fan-curve.service

You can monitor the service now, by using the following command(s):

      systemctl status vega-fan-curve.service
      watch -n 5 journalctl -n -b -u vega-fan-curve.service
