define elasticsearch::add_script (

  $ensure = 'present',
  $source = undef,

) {

  case $ensure {
    /^(present|absent)$/: {
    }
    default: { err ( "Unknown ensure value: '${ensure}'" ) }
  }

  include elasticsearch

  file { "elasticsearch_scripts_${name}":
    ensure  => $ensure,
    path    => "${elasticsearch::params::elasticsearch_dir_conf}/scripts/${name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => "puppet:///modules/${source}",
    require => File['elasticsearch_dir_scripts']
  }
}
