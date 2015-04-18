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
        source => '/vagrant',
    } ->
    python::requirements { '/opt/webvim/webterm/requirements.txt': }

    file { '/etc/init/webterm.conf':
        source => 'puppet:///modules/webterm/webterm.conf',
    }

    file { '/tmp/Dockerfile':
        source => 'puppet:///modules/webterm/Dockerfile',
    }

    exec { 'build_container':
        command => 'docker build --tag demophoon/webvim .',
        path    => '/usr/bin',
        cwd     => '/tmp',
        require => [Class['docker'], File['/tmp/Dockerfile']],
    }
}
