class splunk::service {

  if $splunk::type == 'uf'{
    $binary = '/opt/splunkforwarder/bin/splunk'
  }else {
    $binary = '/opt/splunk/bin/splunk'
  }


  if $::os[family] == "RedHat" {
    if $::os[release][major] == "7" {

      /*service {
        'splunk':
          ensure     => $::splunk::service_ensure,
          hasrestart => true,
          require => File['/etc/systemd/system/splunk.service']
      }*/

    }else{
        service {
          'splunk':
            ensure     => $::splunk::service_ensure,
            hasrestart => true
        }
    }
  }else {
    service {
      'splunk':
        ensure     => $::splunk::service_ensure,
        hasrestart => true
    }
  }


}
