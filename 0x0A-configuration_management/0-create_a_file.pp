<<<<<<< HEAD
# Create a file in /tmp
file {'/tmp/school':
  mode    => '0744',
=======
# Creates a file
file { '/tmp/school':
  ensure  => file,
  path    => /tmp/school
>>>>>>> 2099c78 ( task 0)
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0744',
  content => 'I love Puppet',
}
