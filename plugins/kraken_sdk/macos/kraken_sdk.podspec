#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kraken_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'kraken_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Expose SDK API from kraken.'
  s.description      = <<-DESC
Expose SDK API from kraken.
                       DESC
  s.homepage         = 'https://rax.js.org'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'KrakenTeam' => 'rax-public@alibaba-inc.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
