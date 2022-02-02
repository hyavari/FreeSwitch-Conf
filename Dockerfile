FROM centos:centos7

RUN yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release

RUN yum install -y freeswitch-config-vanilla

RUN yum install -y freeswitch-sounds-en-us-allison-all.noarch
RUN yum install -y freeswitch-sounds-en-us-callie-all.noarch

RUN yum  install -y tcpdump

RUN yum -y install net-tools

RUN yum -y install wget

RUN mkdir /var/log/freeeswitch
RUN touch /var/log/freeswitch/freeswitch.log

RUN rm -rf /etc/freeswitch/sip_profiles/internal-ipv6.xml /etc/freeswitch/sip_profiles/external-ipv6.xml /etc/freeswitch/sip_profiles/external-ipv6
RUN rm -rf /etc/freeswitch/sip_profiles/external*

COPY  freeswitch/autoload_configs /etc/freeswitch/autoload_configs
COPY  freeswitch/directory /etc/freeswitch/directory
COPY  freeswitch/dialplan /etc/freeswitch/dialplan
COPY  freeswitch/sip_profiles /etc/freeswitch/sip_profiles
COPY  freeswitch/vars.xml /etc/freeswitch/
COPY  freeswitch/start.sh /etc/freeswitch/start.sh

##update FS default password
RUN sed -i 's/default_password=1234/default_password='$(openssl rand -hex 16)'/g' /etc/freeswitch/vars.xml
RUN chmod 755 /etc/freeswitch/start.sh

RUN ln -sf /dev/stdout /var/log/freeswitch/freeswitch.log

ENTRYPOINT ["/etc/freeswitch/start.sh"]