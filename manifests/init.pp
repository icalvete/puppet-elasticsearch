class elasticsearch (

  $org_domain               = $elasticsearch::params::org_domain,
  $repo_scheme              = $elasticsearch::params::repo_scheme,
  $repo_domain              = $elasticsearch::params::repo_domain,
  $repo_port                = $elasticsearch::params::repo_port,
  $repo_user                = $elasticsearch::params::repo_user,
  $repo_pass                = $elasticsearch::params::repo_pass,
  $repo_path                = $elasticsearch::params::repo_path,
  $repo_resource            = $elasticsearch::params::package,
  $cluster                  = $elasticsearch::params::elasticsearch_cluster,
  $jetty                    = $elasticsearch::params::jetty,
  $apache                   = $elasticsearch::params::apache,
  $server_alias             = ['elasticsearch'],
  $kibana_server            = '*',
  $elasticsearch_admin      = $elasticsearch::params::elasticsearch_admin,
  $elasticsearch_admin_pass = $elasticsearch::params::elasticsearch_admin_pass,
  $elasticsearch_user       = $elasticsearch::params::elasticsearch_user,
  $elasticsearch_user_pass  = $elasticsearch::params::elasticsearch_user_pass,
  $template                 = undef

) inherits elasticsearch::params {

  if $server_alias {
    if ! is_array($server_alias) {
      fail('server_alias parameter must be un array')
    }
  }

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
    template => $template,
    require  => Class['elasticsearch::service']
  }
  anchor{'elasticsearch::end':
    require => Class['elasticsearch::service']
  }
}
