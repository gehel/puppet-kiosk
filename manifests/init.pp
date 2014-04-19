# = Class: kiosk
#
# This is the main kiosk class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, kiosk class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $kiosk_myclass
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $kiosk_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $kiosk_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in kiosk::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include kiosk"
# - Call kiosk as a parametrized class
#
# See README for details.
#
class kiosk (
  $urls                 = params_lookup('urls'),
  $dashboard_file       = params_lookup('dashboard_file'),
  $refresh_interval     = params_lookup('refresh_interval'),
  $user                 = params_lookup('user'),
  $user_home            = params_lookup('user_home'),
  $boot_config          = params_lookup('boot_config'),
  $boot_config_template = params_lookup('boot_config_template'),
  $raspberry            = params_lookup('raspberry'),
  $framebuffer_width    = params_lookup('framebuffer_width'),
  $framebuffer_height   = params_lookup('framebuffer_height'),
  $display_rotate       = params_lookup('display_rotate'),
  $my_class             = params_lookup('my_class'),
  $absent               = params_lookup('absent'),
  $audit_only           = params_lookup('audit_only', 'global'),
  $noops                = params_lookup('noops'),) inherits kiosk::params {
  if !is_integer($refresh_interval) {
    fail("refresh_interval is not an integer [${refresh_interval}]")
  }

  if !is_integer($framebuffer_width) {
    fail("framebuffer_width is not an integer [${framebuffer_width}]")
  }

  if !is_integer($framebuffer_height) {
    fail("framebuffer_height is not an integer [${framebuffer_height}]")
  }

  if !is_integer($display_rotate) {
    fail("display_rotate is not an integer [${framebuffer_height}]")
  }

  validate_bool($raspberry)

  $bool_absent = any2bool($absent)
  $bool_audit_only = any2bool($audit_only)
  $bool_noops = any2bool($noops)

  # ## Definition of some variables used in the module
  $manage_package = $kiosk::bool_absent ? {
    true  => 'absent',
    false => 'present',
  }

  $manage_file = $kiosk::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $kiosk::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $kiosk::bool_audit_only ? {
    true  => false,
    false => true,
  }

  # ## Managed resources
  if $kiosk::raspberry {
    include kiosk::raspberry
  }

  package { ['chromium', 'libnss3', 'matchbox', 'sqlite3', 'ttf-mscorefonts-installer', 'x11-xserver-utils', 'xwit',]:
    ensure => 'present',
    noop   => $kiosk::bool_noops,
    before => Rclocal::Script['tv-screen'],
  }

  file { '/boot/xinitrc':
    ensure  => 'present',
    content => template('role/kiosk/xinitrc.erb'),
    mode    => '755',
    replace => $kiosk::manage_file_replace,
    audit   => $kiosk::manage_audit,
    noop    => $kiosk::bool_noops,
  }

  file { $dashboard_file:
    ensure  => 'present',
    owner   => $user,
    content => template('role/kiosk/dashboard.html.erb'),
    replace => $kiosk::manage_file_replace,
    audit   => $kiosk::manage_audit,
    noop    => $kiosk::bool_noops,
  }

  rclocal::script { 'tv-screen':
    priority => '99',
    content  => template('role/kiosk/rclocal.erb'),
    autoexec => false,
    audit    => $kiosk::manage_audit,
    noop     => $kiosk::bool_noops,
  }

  # ## Include custom class if $my_class is set
  if $kiosk::my_class {
    include $kiosk::my_class
  }

}
