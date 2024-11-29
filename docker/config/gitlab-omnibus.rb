###################
# External URL
###################
external_url 'gitlab-lb-2018438119.us-east-1.elb.amazonaws.com'

###################
# Database Configuration
###################
# Primary PostgreSQL Settings
postgresql['enable'] = false
postgresql['prevent_primary'] = true
postgresql['pgbouncer_user'] = nil

# Database Connection Settings
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_host'] = 'terraform-20241127171901255500000008.cpow4aauul72.us-east-1.rds.amazonaws.com'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = 'gitlab'
gitlab_rails['db_password'] = 'your_db_password'
gitlab_rails['db_database'] = 'gitlabhq_production'
gitlab_rails['db_encoding'] = 'UTF8'
gitlab_rails['db_socket'] = nil

# Database Performance Settings
gitlab_rails['db_pool'] = 10
gitlab_rails['db_prepared_statements'] = false
gitlab_rails['auto_migrate'] = false

###################
# Redis Configuration
###################
# Disable Local Redis
redis['enable'] = false

# Redis Connection Settings
gitlab_rails['redis_host'] = 'gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_ssl'] = false
gitlab_rails['redis_password'] = nil
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_enable_client'] = true

###################
# Backup Configuration
###################
gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
gitlab_rails['backup_s3_enabled'] = true
gitlab_rails['backup_s3_bucket'] = 'gitlab-backups-bucket789'
gitlab_rails['backup_s3_region'] = 'us-east-1'

###################
# SSH Configuration
###################
gitlab_rails['gitlab_shell_ssh_port'] = 22


###################
# Redis Configuration
###################
# Disable built-in Redis
redis['enable'] = false
redis['bind'] = false
redis['port'] = false
redis['unixsocket'] = false
redis['unixsocketperm'] = nil

# Redis Base Configuration
gitlab_rails['redis_host'] = 'gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_password'] = nil
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_socket'] = nil
gitlab_rails['redis_keepalive_timeout'] = 60
gitlab_rails['redis_tcp_timeout'] = 60

# Redis Connection Pools
gitlab_rails['redis_cache_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_cache_db'] = 0
gitlab_rails['redis_cache_timeout'] = 1

gitlab_rails['redis_queues_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_queues_db'] = 0
gitlab_rails['redis_queues_timeout'] = 1

gitlab_rails['redis_shared_state_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_shared_state_db'] = 0
gitlab_rails['redis_shared_state_timeout'] = 1

# Redis Session Store
gitlab_rails['redis_session_store_enabled'] = true
gitlab_rails['redis_session_store_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379/0"

# Rate Limiting
gitlab_rails['rate_limiting_enabled'] = true
gitlab_rails['rate_limiting_storage_url'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379/0"

###################
# Directory Configuration
###################
# Base Directories
gitlab_rails['shared_path'] = '/var/opt/gitlab/shared'
gitlab_rails['uploads_directory'] = '/var/opt/gitlab/uploads'
log_directory '/var/log/gitlab'

# Git Repository Storage
git_data_dirs({
  "default" => {
    "path" => "/var/opt/gitlab/repositories"
  }
})

# Custom Hooks Directory
gitlab_rails['gitlab_shell']['custom_hooks_dir'] = '/var/opt/gitlab/hooks'

###################
# Logging Configuration
###################
# Container Logging
gitlab_rails['log_directory'] = '/dev/stdout'
unicorn['stderr_logger'] = '/dev/stdout'
unicorn['stdout_logger'] = '/dev/stdout'
gitlab_shell['log_directory'] = '/dev/stdout'
postgresql['log_directory'] = '/dev/stdout'
gitlab_workhorse['log_directory'] = '/dev/stdout'
alertmanager['log_directory'] = '/dev/stdout'
prometheus['log_directory'] = '/dev/stdout'
nginx['error_log_location'] = '/dev/stdout'
nginx['access_log_location'] = '/dev/stdout'

# Disable Standard Logging
logging['log_directory'] = '/var/log/gitlab'
logging['svlogd_size'] = 0
logging['svlogd_num'] = 0
logging['svlogd_timeout'] = 0
logging['svlogd_filter'] = nil
logging['svlogd_udp'] = nil
logging['svlogd_prefix'] = nil

# Disable Logrotate
logrotate['enable'] = false
logging['logrotate_frequency'] = nil
logging['logrotate_size'] = nil
logging['logrotate_rotate'] = nil
logging['logrotate_compress'] = nil
logging['logrotate_method'] = nil
logging['logrotate_postrotate'] = nil
logging['logrotate_dateformat'] = nil

###################
# Service Configuration
###################
# Disable Monitoring Services
prometheus_monitoring['enable'] = false
grafana['enable'] = false

# Disable Runit
runit['enable'] = false
runit['sv_timeout'] = nil

###################
# Misc Configuration
###################
# Time Zone
gitlab_rails['time_zone'] = 'UTC'

# Log Ownership
logging['log_group'] = 'git'
logging['log_user'] = 'git'
gitlab_rails['initial_root_password'] ="admin"