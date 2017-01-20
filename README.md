# nagios-centos
* This container is based on official CentOS:7 image provided on Docker Hub
* This container is built with systemd support(see below steps to enable systemd)

### Start nagios container with systemd:
$ docker run --privileged --name nagios -itd -v /sys/fs/cgroup:/sys/fs/cgroup:ro -P nagios

### If you have your local nagios settings, mount that while starting nagios:
$ docker run --privileged --name nagios -itd -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v [your/local/nagios/etc_folder]:/usr/local/nagios/etc/ -P nagios
