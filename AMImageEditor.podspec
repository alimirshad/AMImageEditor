#
# Be sure to run `pod lib lint AMImageEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMImageEditor'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AMImageEditor.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aly.irshad@gmail.com/AMImageEditor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aly.irshad@gmail.com' => 'ali.irshad@ranosys.com' }
  s.source           = { :git => 'https://github.com/alimirshad/AMImageEditor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'ImageEditorViewController/**/*'
  
  # s.resource_bundles = {
  #   'AMImageEditor' => ['AMImageEditor/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
