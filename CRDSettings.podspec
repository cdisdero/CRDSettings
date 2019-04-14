#
#  Be sure to run `pod spec lint CRDSettings.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.swift_version = '5.0'
s.name         = "CRDSettings"
s.version      = "1.0.5"
s.summary      = "Turnkey solution for presenting and editing settings in your iOS apps."
s.description  = <<-DESC
Simple solution for presenting and editing settings inside of your iOS apps in a ready-made table view UI.
DESC

s.homepage     = "https://github.com/cdisdero/CRDSettings"

# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.license      = "Apache License, Version 2.0"

# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.author             = { "Christopher Disdero" => "info@code.chrisdisdero.com" }

# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.ios.deployment_target = "10.0"

# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.source       = { :git => "https://github.com/cdisdero/CRDSettings.git", :tag => "#{s.version}" }

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#

s.source_files   = 'CRDSettings/**/*.{swift,h,m,storyboard}'
s.resource_bundles = {
    'crdsettings-storyboard' => ['CRDSettings/**/*.{lproj,storyboard}']
}
end
