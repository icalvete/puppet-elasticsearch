define elasticsearch::plugin(
  
  $regexp = undef
){

  if ! $regexp {
    fail('regexpparameter can\'t be empty')
  }

  exec { "add_elasticsearch_plugin_${name}":
    command  => "${elasticsearch::params::home_dir}/bin/plugin install ${name}",
    user     => 'root',
    unless   => "${elasticsearch::params::home_dir}/bin/plugin -l | /bin/grep ${regexp}",
    provider => 'shell'
  }
}
