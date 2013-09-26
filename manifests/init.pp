class elasticsearch (

  $repo_scheme   = elasticsearch::params::repo_scheme,
  $repo_domain   = elasticsearch::params::repo_domain,
  $repo_port     = elasticsearch::params::repo_port,
  $repo_user     = elasticsearch::params::repo_user,
  $repo_pass     = elasticsearch::params::repo_pass,
  $repo_path     = elasticsearch::params::repo_path,
  $repo_resource = elasticsearch::params::package

) inherits elasticsearch::params {

  anchor{'elasticsearch::begin':
    before => Class['elasticsearch::install']
  }

  class{'elasticsearch::install':
    require => Anchor['elasticsearch::begin']
  }

  class{'elasticsearch::config':
    require => Class['elasticsearch::install']
  }

  class{'elasticsearch::service':
    subscribe => Class['elasticsearch::config']
  }

  # Apply index templates (online operation. No restart required)
  class{'elasticsearch::postinstall':
    require => Class['elasticsearch::service']
  }
  anchor{'elasticsearch::end':
    require => Class['elasticsearch::service']
  }
}
