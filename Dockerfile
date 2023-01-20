FROM ghcr.io/borg-fleet/sssd

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes borgbackup openssh-server
RUN mkdir /run/sshd && chown sshd /run/sshd && chown -R sshd /etc/ssh && rm /etc/ssh/ssh_host*

ADD entrypoint.sh /entrypoint.sh

USER sshd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
