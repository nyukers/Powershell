:winrm delete winrm/config/Listener?Address=*+Transport=HTTPS

winrm create winrm/config/Listener?Address=*+Transport=HTTPS

winrm get winrm/config

winrm e winrm/config/listener