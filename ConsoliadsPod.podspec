#
# Be sure to run `pod lib lint ConsoliadsPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConsoliadsPod'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ConsoliadsPod.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'A short description of ConsoliadsPod. Just a description we are using'
                       DESC

  s.homepage         = 'https://github.com/Wazma Ali/ConsoliadsPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wazma Ali' => 'wazma.ali@consoliads.com' }
  s.source           = { :git => 'https://github.com/Wazma Ali/ConsoliadsPod.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/Wazma Ali'

  s.ios.deployment_target = '13.0'

  s.source_files = 'ConsoliadsPod/Classes/**/*'

  s.platforms={
    "ios":"13.0"
}
  
  # s.resource_bundles = {
  #   'ConsoliadsPod' => ['ConsoliadsPod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
