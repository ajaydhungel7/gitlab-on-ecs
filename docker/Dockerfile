FROM gitlab/gitlab-ce:17.3.7-ce.0

ENV GITLAB_HOME="/var/opt/gitlab"

# Combine directory operations and cleanup into a single layer
RUN set -eux; \
    # Remove existing directories and files
    rm -rf \
        /var/opt/gitlab \
        /etc/gitlab \
        /var/log/gitlab \
        /opt/gitlab/sv/logrotate \
        /opt/gitlab/service/logrotate \
        /etc/logrotate.d/gitlab* \
        /var/opt/gitlab/logrotate; \
    # Create fresh directories
    mkdir -p \
        /var/log/gitlab \
        /var/opt/gitlab \
        /etc/gitlab; \
    # Clean package manager cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy configuration file
COPY config/gitlab-omnibus.rb /etc/gitlab/gitlab.rb

# Set up all permissions in a single layer
RUN set -eux; \
    # Set configuration file permissions
    chmod 600 /etc/gitlab/gitlab.rb && \
    chown root:root /etc/gitlab/gitlab.rb && \
    # Set directory permissions
    chown -R root:git \
        /var/opt/gitlab \
        /etc/gitlab \
        /var/log/gitlab && \
    chmod -R 770 \
        /var/opt/gitlab \
        /etc/gitlab \
        /var/log/gitlab && \
    # Set log permissions
    chown -R git:git /var/log/gitlab && \
    chmod -R u+rwX,go-w /var/log/gitlab && \
    # Add root to git group
    usermod -aG git root && \
    # Pre-configure GitLab to load settings on first run
    touch /etc/gitlab/.gitlab-setup

EXPOSE 80 443 22

ENTRYPOINT ["/assets/wrapper"]
CMD ["reconfigure"]
