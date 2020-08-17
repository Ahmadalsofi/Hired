#
# Be sure to run `pod lib lint Hired.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'Hired'
  spec.version          = '0.1.0'
  spec.summary          = 'Hired is a content source for an iOS app.'
  spec.license          = { :type => 'Apache' }
  spec.homepage         = 'https://github.com/zeeshankhan/Hired'
  spec.author           = { 'Zeeshan Khan' => 'izeeshankhan@gmail.com' }
  spec.source           = { :git => 'https://github.com/zeeshankhan/Hired.git', :tag => spec.version.to_s }
  spec.swift_version    = '5.3'
  spec.ios.deployment_target = '13.0'
  spec.source_files = 'Sources/**/*.{swift}'

  spec.resource_bundles = {
    'Hired' => ['Sources/**/*.{xcassets,strings,json}']
  }

end
