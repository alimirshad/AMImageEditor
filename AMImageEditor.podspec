Pod::Spec.new do |s|
  s.name             = 'AMImageEditor'
  s.version          = '1.0.0'
  s.summary          = 'Photo Editor supports drawing and cropping'

  s.description      = <<-DESC
Photo Editor supports drawing, cropping and rotating
                       DESC

  s.homepage         = 'https://github.com/alimirshad/AMImageEditor'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Ali M Irshad' => 'aly.irshad@gmail.com' }
  s.source           = { :git => 'https://github.com/alimirshad/AMImageEditor.git' }
  s.swift_version    = '5.0'

  s.ios.deployment_target = '11.0'
  s.source_files = "ImageEditorViewController/**/*.{swift}"
  s.exclude_files = ""
  s.resources = "ImageEditorViewController/**/*.{png,jpeg,jpg,storyboard,xib,ttf}"

end