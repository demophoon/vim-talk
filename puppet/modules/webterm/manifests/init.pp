class webterm {

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
    }

    vcsrepo { '/opt/webvim':
        source => '/webterm',
    } ->
    python::requirements { '/opt/webvim/requirements.txt': }

    file { '/etc/init/webterm.conf':
        source => 'puppet:///modules/webterm/webterm.conf',
    }

    file { '/tmp/Dockerfile':
        source => 'puppet:///modules/webterm/Dockerfile',
    }

    exec { 'build_container':
        command => 'docker build --tag demophoon/webvim .',
        path    => '/usr/bin',
        cwd     => '/home/vagrant/',
        require => [Class['docker'], File['/tmp/Dockerfile']],
    }
}
