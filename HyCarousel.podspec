#
# Be sure to run `pod lib lint HyCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HyCarousel'
  s.version          = '0.0.1b'
  s.summary          = 'Beautiful, Easy to use, SwiftUI Carousel.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A native, easy to use, easy to implement, highly customizable view, you can embed in your project and start using it.
                       DESC

  s.homepage         = 'https://github.com/WiildchiilD/HyCarousel.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WiildchiilD' => 'lyesderouich@gmail.com' }
  s.source           = { :git => 'https://github.com/WiildchiilD/HyCarousel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'HyCarousel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HyCarousel' => ['HyCarousel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
