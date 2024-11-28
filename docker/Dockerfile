FROM gitlab/gitlab-ce:17.3.7-ce.0

ENV GITLAB_HOME="/var/opt/gitlab"

# Remove existing GitLab directories and files
RUN rm -rf /var/opt/gitlab /etc/gitlab /var/log/gitlab \
    /opt/gitlab/sv/logrotate \
    /opt/gitlab/service/logrotate \
    /etc/logrotate.d/gitlab* \
    /var/opt/gitlab/logrotate

# Create fresh directories
RUN mkdir -p /var/log/gitlab /var/opt/gitlab /etc/gitlab

COPY config/gitlab-omnibus.rb /etc/gitlab/gitlab.rb

RUN chmod 600 /etc/gitlab/gitlab.rb && \
    chown root:root /etc/gitlab/gitlab.rb

RUN chown -R root:git /var/opt/gitlab /etc/gitlab /var/log/gitlab && \
    chmod -R 770 /var/opt/gitlab /etc/gitlab /var/log/gitlab && \
    usermod -aG git root

# Set basic log permissions
RUN chown -R git:git /var/log/gitlab && \
    chmod -R u+rwX,go-w /var/log/gitlab

# Clear package manager cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80 443 22

ENTRYPOINT ["/assets/wrapper"]
CMD ["reconfigure"]
