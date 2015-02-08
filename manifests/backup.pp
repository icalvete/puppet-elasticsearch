class elasticsearch::backup {

  file{ 'elasticsearch_backup_dir':
    ensure => directory,
    path   => "${backup_dir}/elasticsearch",
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0755',
  }

  file {'elasticsearch_set_backup_script':
    ensure  => present,
    path    => '/root/elasticsearch_set_backup.sh',
    content => template("${module_name}/elasticsearch_set_backup.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0744'
  }

  exec { 'elasticsearch_set_backup':
    command => '/root/elasticsearch_set_backup.sh',
    require => File['elasticsearch_set_backup_script']
  }

  file {'elasticsearch_make_backup_script':
    ensure  => present,
    path    => '/root/elasticsearch_make_backup.sh',
    content => template("${module_name}/elasticsearch_make_backup.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0744'
  }

  cron { "add_backup_elasticsearch_${::hostname}":
    command => '/root/elasticsearch_make_backup.sh',
    user    => 'root',
    hour    => '6',
    minute  => '0',
    require => File['elasticsearch_make_backup_script']
  }
}

