class elasticsearch::config {

  $hostname    = $::hostname
  $ipaddress   = $::ipaddress

  $script_name = 'clean_indexes.php'
  $script_path = "/root/${$script_name}"

  file { $elasticsearch::params::elasticsearch_dir_conf:
    ensure => directory
  }

  file {'elasticsearch_conf_file':
    ensure  => present,
    path    => "${elasticsearch::params::elasticsearch_dir_conf}/elasticsearch.yml",
    content => template("${module_name}/elasticsearch.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'config_elasticsearch_login':
    path   => "${elasticsearch::params::elasticsearch_dir_conf}/logging.yml",
    source => "puppet:///modules/${module_name}/logging.yml",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file {'clean_indexes':
    ensure => present,
    path   => $script_path,
    source => "puppet:///modules/${module_name}/${script_name}",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  cron { 'add_clean_indexes':
    command => "php ${script_path}",
    user    => root,
    hour    => '3',
    minute  => '0',
    require => File['clean_indexes']
  }
}
