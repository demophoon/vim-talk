Vcsrepo {
    owner    => 'vagrant',
    provider => git,
    ensure   => present,
}

class { 'python':
    pip => true,
}

group { 'docker':
    ensure => present,
} ->
class { 'docker':
    version      => '1.5.0',
    docker_users => ['vagrant'],
} ->
vcsrepo { '/opt/webvim':
    source => 'https://github.com/demophoon/webvim',
} ->
python::requirements { '/opt/webvim/requirements.txt': }

exec { 'build_container':
    command => 'docker build --tag demophoon/webvim .',
    path    => '/usr/bin',
    cwd     => '/home/vagrant/',
    require => [Class['docker']],
}
