# Use the official GitLab CE image as the base
FROM gitlab/gitlab-ce:latest

# Add the custom gitlab.rb configuration file
COPY config/gitlab-omnibus.rb /etc/gitlab/gitlab.rb

# Ensure proper permissions for GitLab directories and configuration file
RUN chmod 600 /etc/gitlab/gitlab.rb && \
    chmod -R 777 /var/opt/gitlab && \
    chmod -R 777 /var/log/gitlab && \
    chmod -R 777 /etc/gitlab

# Set the container's default command to reconfigure and start GitLab at runtime
CMD ["sh", "-c", "gitlab-ctl reconfigure && gitlab-ctl tail"]
