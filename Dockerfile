FROM ghcr.io/borg-fleet/sssd

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes borgbackup openssh-server
RUN pam-auth-update --enable mkhomedir
RUN mkdir /run/sshd && rm /etc/ssh/ssh_host*

ADD entrypoint.sh /entrypoint.sh

EXPOSE 22

CMD ["/usr/sbin/sshd","-D", "-e"]
