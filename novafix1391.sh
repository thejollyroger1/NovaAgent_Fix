#/bin/bash
#This script will automatically fix 1.39 nova-agent issues related to updating the systemd-python package

if [ -d /usr/share/nova-agent/1.39.1/ ] ; then
    echo "Nova-agent version 1.39.1 appears to be installed, making changes to fix Nova-agent startup"
    touch /usr/lib/systemd/system/nova-agent.service
    echo '[Unit]
Description=nova-agent service
After=xe-linux-distribution.service

[Service]
EnvironmentFile=/etc/nova-agent.env
ExecStart=/usr/sbin/nova-agent -n -l info /usr/share/nova-agent/nova-agent.py

[Install]
WantedBy=multi-user.target' > /usr/lib/systemd/system/nova-agent.service

    echo 'LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/share/nova-agent/1.39.1/lib"
PYTHONPATH="${PYTHONPATH}:/usr/share/nova-agent/1.39.1/lib/python2.6/site-packages:/usr/share/nova-agent/1.39.1/lib/python2.6/"' > /etc/nova-agent.env

    systemctl daemon-reload

    chkconfig nova-agent on
else
    echo "Nova-agent version 1.39.1 does not appear to be installed" && exit
fi
