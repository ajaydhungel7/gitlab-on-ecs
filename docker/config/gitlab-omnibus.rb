# External URL
external_url 'gitlab-lb-2018438119.us-east-1.elb.amazonaws.com' 
# Database configuration
postgresql['enable'] = false
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_host'] = 'terraform-20241127171901255500000008.cpow4aauul72.us-east-1.rds.amazonaws.com'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = 'gitlab' # Replace with your DB username
gitlab_rails['db_password'] = 'your_db_password' # Replace with your DB password
gitlab_rails['db_database'] = 'gitlabhq_production' # Adjust if your DB name is different



# Additional configurations (optional)
gitlab_rails['db_pool'] = 10
gitlab_rails['db_prepared_statements'] = false
postgresql['enable'] = false
postgresql['prevent_primary'] = true
gitlab_rails['db_socket'] = nil
gitlab_rails['gitlab_shell_ssh_port'] = 22
gitlab_rails['db_encoding'] = 'UTF8'
gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
gitlab_rails['backup_s3_enabled'] = true
gitlab_rails['backup_s3_bucket'] = 'gitlab-backups-bucket789'
gitlab_rails['backup_s3_region'] = 'us-east-1'
# Disable database tasks
gitlab_rails['auto_migrate'] = false
postgresql['pgbouncer_user'] = nil


# Disable local Redis
redis['enable'] = false

# Configure external Redis connection
gitlab_rails['redis_host'] = 'gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_ssl'] = false
gitlab_rails['redis_password'] = nil  # Set if you have AUTH enabled
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_enable_client'] = true

# Explicitly disable Redis socket
gitlab_rails['redis_socket'] = nil

# Redis connection settings
gitlab_rails['redis_keepalive_timeout'] = 60

# Redis TCP connection
gitlab_rails['redis_tcp_timeout'] = 60

# Configure Redis connection pools
gitlab_rails['redis_cache_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_cache_db'] = 0
gitlab_rails['redis_cache_timeout'] = 1

gitlab_rails['redis_queues_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_queues_db'] = 0
gitlab_rails['redis_queues_timeout'] = 1

gitlab_rails['redis_shared_state_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379"
gitlab_rails['redis_shared_state_db'] = 0
gitlab_rails['redis_shared_state_timeout'] = 1

# Disable Redis local socket
redis['unixsocket'] = false

# Explicitly set Redis connection method to TCP
redis['bind'] = false
redis['port'] = false
redis['unixsocketperm'] = nil

# Rate limiting configuration (uses Redis)
gitlab_rails['rate_limiting_enabled'] = true
gitlab_rails['rate_limiting_storage_url'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379/0"

# Session store configuration
gitlab_rails['redis_session_store_enabled'] = true
gitlab_rails['redis_session_store_instance'] = "redis://gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379/0"
# Disable the built-in Redis
redis['enable'] = false
gitlab_rails['redis_host'] = 'gitlab-redis.xdj1he.0001.use1.cache.amazonaws.com:6379'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_password'] = nil
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_socket'] = nil
gitlab_rails['redis_keepalive_timeout'] = 60

log_directory '/var/log/gitlab'
gitlab_rails['time_zone'] = 'UTC' 

gitlab_rails['shared_path'] = '/var/opt/gitlab/shared'
gitlab_rails['uploads_directory'] = '/var/opt/gitlab/uploads'

# Directory for storing Git repositories
git_data_dirs({
  "default" => {
    "path" => "/var/opt/gitlab/repositories"
  }
})

# Log directory
logging['log_directory'] = '/var/log/gitlab'

# Configuration directory (EFS mount)
gitlab_rails['gitlab_shell']['custom_hooks_dir'] = '/var/opt/gitlab/hooks'

#logging
# Disable logrotate
logrotate['enable'] = false

# Disable logging configuration
logging['svlogd_size'] = 0
logging['svlogd_num'] = 0
logging['svlogd_timeout'] = 0
logging['svlogd_filter'] = nil
logging['svlogd_udp'] = nil
logging['svlogd_prefix'] = nil

# Disable all logrotate settings
logging['logrotate_frequency'] = nil
logging['logrotate_size'] = nil
logging['logrotate_rotate'] = nil
logging['logrotate_compress'] = nil
logging['logrotate_method'] = nil
logging['logrotate_postrotate'] = nil
logging['logrotate_dateformat'] = nil

# Disable runit log service
runit['enable'] = false
runit['sv_timeout'] = nil

# Configure logging to stdout for container-friendly logging
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

# Disable other services that might interfere
prometheus_monitoring['enable'] = false
grafana['enable'] = false

# Set proper ownership
logging['log_group'] = 'git'
logging['log_user'] = 'git'