FROM ghcr.io/borg-fleet/sssd

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes borgbackup openssh-server && \
    rm -rf /var/lib/apt/lists/*
RUN pam-auth-update --enable mkhomedir
RUN mkdir /run/sshd && rm /etc/ssh/ssh_host*

ADD entrypoint.sh /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D", "-e"]
