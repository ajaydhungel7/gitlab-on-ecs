


# Use the official GitLab CE image as the base
FROM gitlab/gitlab-ce:latest

# Add the custom omnibus.rb file
COPY config/gitlab-omnibus.rb /etc/gitlab/gitlab.rb

# Ensure proper permissions for the omnibus.rb file
RUN chmod 600 /etc/gitlab/gitlab.rb && \

    # Change permissions for GitLab directories
    chmod -R 777 /var/opt/gitlab && \
    chmod -R 777 /var/log/gitlab && \
    chmod -R 777 /etc/gitlab && \

    # Reconfigure GitLab to apply changes
    gitlab-ctl reconfigure

# Optional: Expose ports (if not already handled by the base image)
EXPOSE 80 443 22
