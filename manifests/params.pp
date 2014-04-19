# Class: kiosk::params
#
# This class defines default parameters used by the main module class kiosk
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to kiosk class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class kiosk::params {
  # ## Application related parameters

  $urls = ['http://www.wikipedia.org', 'http://en.wikipedia.org/wiki/HTML_element#Frames',]
  $refresh_interval = 10000
  $user = 'pi'
  $user_home = '/home/pi'
  $dashboard_file = '/home/pi/dashboard.html'
  $boot_config = '/boot/config.txt'
  $boot_config_template = 'role/kiosk/boot-config.txt.erb'
  $display_rotate = 0
  $raspberry = true

  # General Settings
  $my_class = ''
  $absent = false
  $audit_only = false
  $noops = false

}
