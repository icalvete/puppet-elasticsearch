class elasticsearch::params {

  $org_domain               = hiera('org_domain')

  $jetty                    = false
  $elasticsearch_admin      = hiera('elasticsearch_admin')
  $elasticsearch_admin_pass = hiera('elasticsearch_admin_pass')
  $elasticsearch_user       = hiera('elasticsearch_user')
  $elasticsearch_user_pass  = hiera('elasticsearch_user_pass')

  $apache                   = false

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $elasticsearch_dir_conf     = '/etc/elasticsearch'
      $elasticsearch_vip          = hiera('elasticsearch_vip')
      $elasticsearch_cluster_name = hiera('elasticsearch_cluster_name')

      $repo_scheme                = hiera('sp_repo_scheme')
      $repo_domain                = hiera('sp_repo_domain')
      $repo_port                  = hiera('sp_repo_port')
      $repo_user                  = hiera('sp_repo_user')
      $repo_pass                  = hiera('sp_repo_pass')
      $repo_path                  = hiera('sp_repo_path')
      $package                    = hiera('elasticsearch_package')
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }
}
