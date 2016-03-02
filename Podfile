platform :ios, '9.0'
use_frameworks!

pod 'MBProgressHUD', '~> 0.9.2'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'SlackWebHook/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
