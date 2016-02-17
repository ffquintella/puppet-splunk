# splunk::passwd should be called  to manage your splunk users
# by default passwd will be placed in $splunkhome/etc
# === Parameters
#
# [users_array]
#   array representing the lines in the passwd file
#
#
# class { 'splunk::inputs':
#   users_array   => [ {
#       login => 'admin'
#       hash => $6$DSfhdf348fgdfdfgSDJHGF
#       name => 'Administrator'
#       groups => 'admin'
#       email => 'admin@adm.com'} ,
#   {
#       login => 'admin2'
#       hash => $6$DSfhdf348fgdfdfgSDJHGF
#       name => 'Administrator'
#       groups => 'admin'
#       email => 'admin2@adm.com'}
#  ]
#  }
#
class splunk::passwd (
  $path         = "${::splunk::splunkhome}/etc",
  $users_array   = []
  ) {
  # Validate hash
  if ( $users_array ) {
    validate_array($users_array)
  }
 
  file{ "${path}/passwd":
    ensure             => present,
    owner              => root,
    group              => root,
    content            => template('splunk/etc/splunk-passwd.erb'),
    source_permissions => ignore
  }

}
