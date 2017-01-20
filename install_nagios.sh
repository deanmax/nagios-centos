useradd --system --home /home/nagios -M nagios
groupadd --system nagcmd
usermod -a -G nagcmd nagios
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.0.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
wget http://sourceforge.net/projects/nagios/files/nrpe-3.x/nrpe-3.0.tar.gz
tar xvf nagios-4.2.0.tar.gz
tar xvf nagios-plugins-2.1.2.tar.gz
tar xvf nrpe-3.0.tar.gz

#installing nagios
cd /tmp/nagios-4.2.0
./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-mail=/usr/sbin/sendmail
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
mkdir -p /usr/local/nagios/var/spool
mkdir -p /usr/local/nagios/var/spool/checkresults
chown -R nagios:nagios /usr/local/nagios/var

#installing plugins
cd /tmp/nagios-plugins-2.1.2/
./configure --with-nagios-user=nagios --with-nagios-group=nagios --enable-perl-modules --enable-extra-opts
make
make install

cd /tmp/nrpe-3.0/
./configure --with-nrpe-user=nagios --with-nrpe-group=nagios --with-nagios-user=nagios --with-nagios-group=nagios  --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make all
make install-plugin

usermod -G nagios apache
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin P@ssw0rd
rm -rf /tmp/* /var/tmp/*
