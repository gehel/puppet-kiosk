class kiosk::raspberry () {

  file { '/boot/config.txt':
    ensure => $kiosk::manage_file,
    path => $kiosk::boot_config,
    content => template('role/kiosk/boot-config.txt.erb'),
    mode    => '755',
    replace => $kiosk::manage_file_replace,
    audit   => $kiosk::manage_audit,
    noop    => $kiosk::bool_noops,
  }

}