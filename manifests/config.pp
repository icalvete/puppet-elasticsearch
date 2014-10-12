class elasticsearch::config {

  $hostname    = $::hostname
  $ipaddress   = $::ipaddress

  $script_name = 'clean_indexes.php'
  $script_path = "/root/${$script_name}"

  file { 'elasticsearch_dir':
    ensure => directory,
    path   => $elasticsearch::params::elasticsearch_dir_conf
  }

  file { 'elasticsearch_dir_scripts':
    ensure  => directory,
    path    => "${elasticsearch::params::elasticsearch_dir_conf}/scripts",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['elasticsearch_dir']
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

  if $elasticsearch::jetty {

    file { 'config_elasticsearch_keystore':
      path   => "${elasticsearch::params::elasticsearch_dir_conf}/keystore",
      source => "puppet:///modules/${module_name}/keystore",
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file {'config_elasticsearch_jetty_users':
      ensure  => present,
      path    => "${elasticsearch::params::elasticsearch_dir_conf}/realm.properties",
      content => template("${module_name}/realm.properties.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $elasticsearch::apache {

    apache2::site{'elasticsearch.vhost.conf':
      source  => 'elasticsearch/web/apache2/elasticsearch.vhost.conf.erb',
      require => Class['roles::apache2_server']
    }
  }
}
