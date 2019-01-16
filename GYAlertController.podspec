#
# Be sure to run `pod lib lint GYAlertController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GYAlertController'
  s.version          = '0.1.5'
  s.summary          = 'A custom UI Component like UIAlertController. But it provides great flexibility and dynamism.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A custom UI Component like UIAlertController. But it provides great flexibility and dynamism. You have more choices to make difference, such as title style, message style, alert title style and so on. Support iPhoneX and iOS 11.
                       DESC

  s.homepage         = 'https://github.com/Goyaya/GYAlertController'
  # s.screenshots     = 'https://github.com/Goyaya/GYAlertController/blob/master/Snapshots/fill-p@2x.png?raw=true', 'https://github.com/Goyaya/GYAlertController/blob/master/Snapshots/empty-p@2x.png?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gyang' => 'goyaya@yeah.net' }
  s.source           = { :git => 'https://github.com/Goyaya/GYAlertController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GYAlertController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GYAlertController' => ['GYAlertController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
