class elasticsearch::postinstall {

  file { 'config_logstash_template':
    path   => "${elasticsearch::params::elasticsearch_dir_conf}/logstash_template.sh",
    source => "puppet:///modules/${module_name}/logstash_template.sh",
    owner  => 'root',
    group  => 'root',
    mode   => '0744'
  }

  #Load elasticsearch takes some time. To apply templates, service must be running.
  exec {'apply_logstash_template':
    command   => "${elasticsearch::params::elasticsearch_dir_conf}/logstash_template.sh",
    tries     => 3,
    try_sleep => 15,
    require   => File['config_logstash_template']
  }
}
