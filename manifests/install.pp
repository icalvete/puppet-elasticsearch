class elasticsearch::install {

  realize Package['openjdk-7-jre']

  common::down_resource {'elasticsearch_get_package':
    scheme   => $elasticsearch::repo_scheme,
    domain   => $elasticsearch::repo_domain,
    port     => $elasticsearch::repo_port,
    user     => $elasticsearch::repo_user,
    pass     => $elasticsearch::repo_pass,
    path     => $elasticsearch::repo_path,
    resource => $elasticsearch::repo_resource,
    require  => Package['openjdk-7-jre']
  }

  exec {'elasticsearch_install_package':
    cwd     => '/tmp/',
    command => "/usr/bin/dpkg -i ${elasticsearch::repo_resource}",
    require => Common::Down_resource['elasticsearch_get_package'],
    unless  => '/usr/bin/dpkg -l elasticsearch | grep ii'
  }

  if $elasticsearch::jetty {
    exec{ 'elasticsearch_install_jetty':
      command  => '/usr/share/elasticsearch/bin/plugin -url https://oss-es-plugins.s3.amazonaws.com/elasticsearch-jetty/elasticsearch-jetty-1.2.1.zip -install elasticsearch-jetty-1.2.1',
      user     => 'root',
      provider => 'shell',
      unless   => '/usr/bin/test -d /usr/share/elasticsearch/plugins/jetty-1.2.1/',
      require  => Exec['elasticsearch_install_package']
    }
  }
  
  elasticsearch::plugin{'elasticsearch/elasticsearch-cloud-aws/2.4.1':
    regexp  => 'cloud-aws',
    require => Exec['elasticsearch_install_package']
  }

}
