# systemd service install for vega-underclock-oc

      sudo cp vega-underclock-oc /usr/local/bin
      sudo chmod +x /usr/local/bin/vega-underclock-oc
      sudo cp systemd/vega-underclock-oc.service /etc/systemd/system
      sudo systemctl start vega-underclock-oc.service
      sudo systemctl enable vega-underclock-oc.service

You can monitor the service now, by using the following command(s):

      systemctl status vega-underclock-oc.service
      watch -n 5 journalctl -n -b -u vega-underclock-oc.service
      
To enable debug for the above `journalctl` command, do the following:

      sudo vi /usr/local/bin/vega-underclock-oc

Set:

      DEBUG=1
      sudo systemctl start vega-underclock-oc.service
