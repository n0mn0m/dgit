FROM alpine:latest

RUN apk add \
    git \
    openssh \
    curl \
    vim \
    jq

COPY sshd_config /sshd_config

# Add git user with home directory ready for SSH config and a random password.
# The password won't actually be used for anything, but needs to be set for
# the system to consider the account valid.
RUN adduser -Dh /home/git -s /usr/bin/git-shell git && \
    echo "git:\$(date +%s | sha256sum | base64 | head -c 64 ; echo)" | chpasswd

RUN mkdir /home/git/.ssh
RUN chmod 700 /home/git/.ssh
RUN chown -R git:git /home/git

COPY git-shell-commands/ /home/git/git-shell-commands
# Add the cronjob to update the git mirrors once per hour
RUN echo -e "0 * * * * /home/git/git-shell-commands/update-mirrors.sh\n" | crontab -u git -


# Used to persist host SSH keys and configuration
VOLUME /etc/ssh
# Used to persist git repos and config
VOLUME /home/git

EXPOSE 22

COPY entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
