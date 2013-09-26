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
}
