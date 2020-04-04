#!/usr/bin/env bash

####################################################################################################################################
#  Bootstrap script to
#     1. Install aws cloudwatch logs agent ansible
#     2. Docker login to set ~/.docker/config.json
#     3. Join the instance to ECS cluster
#     4. Create the metricbeat.yml config to send metrics to elasticsearch
#     5. Update awslogs cloudwatch agent to send logs to cloudwatchh loggroup
#     6. Send custom metrics to the cloudwatch by running the crontab
#
####################################################################################################################################

function install_packages() {
    yum update -y
    yum install -y awslogs ansible perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64 unzip
    }

function docker_login() {
    mkdir ~/.docker
    docker login quay.io --username hooq+techacc -p ${private_registry_token} 2>/dev/null
}

function get_aws_metadata() {
    # Set the region to send CloudWatch Logs data to (the region where the container instance is located)
    region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
    # Set the ip address of the node
    container_instance_id=$(curl 169.254.169.254/latest/meta-data/instance-id)
}

function join_ecs_cluster() {
    echo ECS_CLUSTER="${cluster_name}" >> /etc/ecs/ecs.config
    echo ECS_IMAGE_PULL_BEHAVIOR=${ecs_image_pull_behavior} >> /etc/ecs/ecs.config
    echo ECS_DISABLE_IMAGE_CLEANUP=${ecs_disable_image_cleanup} >> /etc/ecs/ecs.config
    echo ECS_IMAGE_CLEANUP_INTERVAL=${ecs_image_cleanup_interval} >> /etc/ecs/ecs.config
    echo ECS_IMAGE_MINIMUM_CLEANUP_AGE=${ecs_image_minimum_cleanup_age} >> /etc/ecs/ecs.config
    echo ECS_NUM_IMAGES_DELETE_PER_CYCLE=${ecs_num_images_delete_per_cycle} >> /etc/ecs/ecs.config
    echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=${ecs_engine_task_cleanup_wait_duration} >> /etc/ecs/ecs.config
}

function configure_awslogs() {
    get_aws_metadata
    sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf
    # Inject the CloudWatch Logs configuration file contents
    cat > /etc/awslogs/awslogs.conf <<- EOF
    [general]
    state_file = /var/lib/awslogs/agent-state
    [/var/log/dmesg]
    file = /var/log/dmesg
    log_group_name = ${cloudwatch_prefix}/var/log/dmesg
    log_stream_name = ${cluster_name}/$${container_instance_id}
    [/var/log/messages]
    file = /var/log/messages
    log_group_name = ${cloudwatch_prefix}/var/log/messages
    log_stream_name = ${cluster_name}/$${container_instance_id}
    datetime_format = %b %d %H:%M:%S
    [/var/log/docker]
    file = /var/log/docker
    log_group_name = ${cloudwatch_prefix}/var/log/docker
    log_stream_name = ${cluster_name}/$${container_instance_id}
    datetime_format = %Y-%m-%dT%H:%M:%S.%f
    [/var/log/ecs/ecs-init.log]
    file = /var/log/ecs/ecs-init.log.*
    log_group_name = ${cloudwatch_prefix}/var/log/ecs/ecs-init.log
    log_stream_name = ${cluster_name}/$${container_instance_id}
    datetime_format = %Y-%m-%dT%H:%M:%SZ
    [/var/log/ecs/ecs-agent.log]
    file = /var/log/ecs/ecs-agent.log.*
    log_group_name = ${cloudwatch_prefix}/var/log/ecs/ecs-agent.log
    log_stream_name = ${cluster_name}/$${container_instance_id}
    datetime_format = %Y-%m-%dT%H:%M:%SZ
    [/var/log/ecs/audit.log]
    file = /var/log/ecs/audit.log.*
    log_group_name = ${cloudwatch_prefix}/var/log/ecs/audit.log
    log_stream_name = ${cluster_name}/$${container_instance_id}
    datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF
}




function run_services() {
  # Start the awslogs cloudwatch agent
  service awslogs start
  # On boot enable awslogs agent
  chkconfig awslogs on
  # Start the ecs-agent to join the EC2 instance in the ECS Cluster
  initctl start ecs
  cd /tmp ; yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  initctl start amazon-ssm-agent
  
}

install_packages
docker_login
join_ecs_cluster
configure_awslogs
run_services
