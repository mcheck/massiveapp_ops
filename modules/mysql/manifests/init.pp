
class mysql {
	package {
		"mysql-server":
			ensure => installed,
			before => File["/etc/mysql/my.cnf"]
	}

	service {
		"mysql":
		  provider	=> upstart,
		  ensure	=> running,
		  enable	=> true,
		  subscribe	=> File["/etc/mysql/my.cnf"]
	}

	file {
	  "/etc/mysql/my.cnf":
		source	=> "puppet:///modules/mysql/my.cnf",
		mode	=> 644,
		owner	=> root,
		group	=> root
	}

	exec {
	  "mysql_password":
		unless => "mysqladmin -uroot -proot status",
		command => "mysqladmin -uroot password root",
		require => Service[mysql];
		
	  "massiveapp_db":
		unless => "mysql -uroot -proot massiveapp_production",
		command => "mysql -uroot -proot -e 'create database massiveapp_production'",
		require => Exec["mysql_password"]
	}

}