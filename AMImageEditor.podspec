Pod::Spec.new do |s|

  s.name         = "AMImageEditor"
  s.version      = "0.0.1"
  s.summary      = "Simple image editor"
  s.platform     = :ios, "7.0"
  s.source_files  = "ImageEditorViewController/*"
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
end