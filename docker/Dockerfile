# Start from the official GitLab Omnibus image
FROM gitlab/gitlab-ce:latest

# Copy your custom configuration file into the container
COPY config/gitlab-omnibus.conf /etc/gitlab/gitlab.rb

# Optional: You can add additional configuration files as needed
# COPY other-config-file.conf /etc/gitlab/other-config.conf

# Ensure permissions are set correctly
RUN chown -R root:root /var/opt/gitlab && chmod -R 0755 /var/opt/gitlab

# Expose the ports that GitLab uses
EXPOSE 80 443 22

# Start the GitLab services
CMD ["gitlab-ctl", "reconfigure"]