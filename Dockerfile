FROM centos:7
MAINTAINER ruiyu wang  "deanmax@gmail.com"

EXPOSE 22 80
VOLUME [ "/sys/fs/cgroup" ]
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum install -y initscripts \
                openssh-clients \
                openssh-server \
                wget \
                sendmail \
                sendmail-cf \
                httpd \
                httpd-tools \
                php \
                perl-tests \
                openssl \
                openssl-libs \
                openssl-devel \
                mailx

# install nagios
COPY install_nagios.sh /root/install_nagios.sh
RUN chmod +x /root/install_nagios.sh; sync
RUN /bin/bash -c /root/install_nagios.sh \
    && rm /root/install_nagios.sh
RUN systemctl enable httpd
RUN systemctl enable nagios

# update root password
RUN echo "root:P@ssw0rd" | chpasswd
RUN systemctl enable sshd

# update your smtp relay server
#RUN echo "define(\`SMART_HOST', \`mailhost.engba.veritas.com')" >> /etc/mail/sendmail.mc
RUN m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
RUN systemctl enable sendmail

# change timezone
RUN ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# init
CMD ["/usr/sbin/init"]
