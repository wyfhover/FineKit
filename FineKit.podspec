
Pod::Spec.new do |s|
  s.name             = 'FineKit'
  s.version          = '1.0.3'
  s.summary          = 'Some convenient kits by Fine'

  s.description      = <<-DESC
  FineKit 私人工具类，包含拓展、文件管理、语言管理、常量、全局方法、XML解析等等，开发过程中封装的便利工具
                       DESC

  s.homepage         = 'https://github.com/wyfhover/FineKit'
  s.license          = 'MIT'
  s.author           = { 'Fine' => 'wyfhover@163.com' }
  s.source           = { :git => 'https://github.com/wyfhover/FineKit.git', :tag => s.version }
  
  s.platform = :ios

  s.ios.deployment_target = '12.0'
  
  s.swift_version = ['5']

  s.subspec 'Extension' do |ex|
    ex.source_files = 'FineKit/Classes/Extension/*.swift'
    ex.frameworks = 'Foundation', 'UIKit'
  end

  s.subspec 'FileManager' do |fm|
    fm.source_files = 'FineKit/Classes/FileManager/*.swift'
    fm.frameworks = 'Foundation', 'UIKit'
  end

  s.subspec 'LanguageManager' do |lm|
    lm.source_files = 'FineKit/Classes/LanguageManager/*.swift'
    lm.frameworks = 'Foundation', 'UIKit'
  end

  s.subspec 'Tools' do |ts|
    ts.source_files = 'FineKit/Classes/Tools/*.swift'
    ts.frameworks = 'Foundation', 'UIKit'
  end

  s.subspec 'XMLTool' do |xmlt|
    xmlt.source_files = 'FineKit/Classes/XMLTool/*.swift'
    xmlt.frameworks = 'Foundation', 'UIKit'
  end

end
