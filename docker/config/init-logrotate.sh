#!/bin/bash
# Clean up any existing logrotate state
rm -rf /opt/gitlab/sv/logrotate/supervise
rm -rf /opt/gitlab/service/logrotate

# Create required directories
mkdir -p /opt/gitlab/sv/logrotate/log
mkdir -p /opt/gitlab/sv/logrotate/supervise
mkdir -p /opt/gitlab/service

# Set proper permissions
chown -R git:git /opt/gitlab/sv/logrotate
chmod -R u+rwX,go-w /opt/gitlab/sv/logrotate

# Create symlink for service
ln -sf /opt/gitlab/sv/logrotate /opt/gitlab/service/

# Initialize logrotate
gitlab-ctl start logrotate