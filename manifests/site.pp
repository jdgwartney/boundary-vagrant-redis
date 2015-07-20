# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

node /^ubuntu/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    require => Class['redis'],
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
    creates => '/vagrant/.locks/update-apt-packages',
  }

  class { 'redis':
    require => Exec['update-apt-packages']
  }

  class { 'boundary':
    token => $boundary_api_token,
  }

}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    require => Class['redis'],
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  class { 'redis':
    require => Package['epel-release']
  }

}

node /^centos/ {

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    require => Class['redis'],
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  class { 'redis':
    require => Package['epel-release']
  }

  class { 'boundary':
    token => $boundary_api_token,
  }

}
