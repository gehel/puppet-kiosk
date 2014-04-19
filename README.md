# Puppet module: kiosk

This is a Puppet module for kiosk
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official git repository: http://github.com/gehel/puppet-kiosk

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install kiosk with default settings

        class { 'kiosk': }

* Install a specific version of kiosk package

        class { 'kiosk':
          version => '1.0.1',
        }

* Remove kiosk resources

        class { 'kiosk':
          absent => true
        }

* Enable auditing without without making changes on existing kiosk configuration *files*

        class { 'kiosk':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'kiosk':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'kiosk':
          source => [ "puppet:///modules/example42/kiosk/kiosk.conf-${hostname}" , "puppet:///modules/example42/kiosk/kiosk.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'kiosk':
          source_dir       => 'puppet:///modules/example42/kiosk/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'kiosk':
          template => 'example42/kiosk/kiosk.conf.erb',
        }

* Automatically include a custom subclass

        class { 'kiosk':
          my_class => 'example42::my_kiosk',
        }



## TESTING
[![Build Status](https://travis-ci.org/example42/puppet-kiosk.png?branch=master)](https://travis-ci.org/example42/puppet-kiosk)
