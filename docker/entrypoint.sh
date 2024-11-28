#!/bin/bash
set -e

# Run reconfigure to apply the configuration
gitlab-ctl reconfigure

# Run GitLab services as PID 1
exec /opt/gitlab/embedded/bin/runsvdir-start