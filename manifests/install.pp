class splunk::install (
  $license          = $::splunk::license,
  $pkgname          = $::splunk::pkgname,
  $splunkadmin      = $::splunk::splunkadmin,
  $localusers       = $::splunk::localusers,
  $splunkhome       = $::splunk::splunkhome,
  $type             = $::splunk::type,
  $version          = $::splunk::version,
  $package_source   = $::splunk::package_source,
  $package_provider = $::splunk::package_provider,
  ) {

  package { $pkgname:
    ensure   => $version,
    provider => $package_provider,
    source   => $package_source,
  }

  if $splunk::type == 'uf'{
    $binary = '/opt/splunkforwarder/bin/splunk'
    $run_dir = '/opt/splunkforwarder/var/run/splunk'
  }else {
    $binary = '/opt/splunk/bin/splunk'
    $run_dir = '/opt/splunk/var/run/splunk'
  }

  if $::os[family] == "RedHat" {
    if $::os[release][major] == "7" {
      # Revisar este script... Esta com problemas
      /*file{'/etc/systemd/system/splunk.service':
        ensure  => present,
        content => template('splunk/etc/systemd/system/splunk.erb'),
      }*/
    } else {
      file { '/etc/init.d/splunk':
        ensure => present,
        mode   => '0700',
        owner  => 'root',
        group  => 'root',
        source => "puppet:///modules/splunk/${::osfamily}/etc/init.d/${pkgname}"
      }
    }
  } else{
      file { '/etc/init.d/splunk':
        ensure => present,
        mode   => '0700',
        owner  => 'root',
        group  => 'root',
        source => "puppet:///modules/splunk/${::osfamily}/etc/init.d/${pkgname}"
      }
  }

  # inifile
  ini_setting { 'Server Name':
    ensure  => present,
    path    => "${splunkhome}/etc/system/local/server.conf",
    section => 'general',
    setting => 'serverName',
    value   => $::fqdn,
  } ->
  ini_setting { 'SSL v3 only':
    ensure  => present,
    path    => "${splunkhome}/etc/system/local/server.conf",
    section => 'sslConfig',
    setting => 'supportSSLV3Only',
    value   => 'True',
  } /* ->

  file { "${splunkhome}/etc/splunk.license":
    ensure => present,
    mode   => '0644',
    owner  => 'splunk',
    group  => 'splunk',
    backup => true,
    source => $license,
  } ->

  file { "${splunkhome}/etc/passwd":
    ensure  => present,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    backup  => true,
    content => template('splunk/opt/splunk/etc/passwd.erb'),
  } ->

  # recursively copy the contents of the auth dir
  # This is causing a restart on the second run. - TODO
  file { "${splunkhome}/etc/auth":
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => 'puppet:///modules/splunk/noarch/opt/splunk/etc/auth',
  }*/
}
