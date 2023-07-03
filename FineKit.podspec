#
# Be sure to run `pod lib lint FineKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FineKit'
  s.version          = '1.0.1'
  s.summary          = 'Some convenient kits by Fine'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
私人工具类，包含拓展、文件管理、语言管理、常量、全局方法、XML解析等等，开发过程中封装的便利工具
                       DESC

  s.homepage         = 'https://github.com/wyfhover/FineKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { 'Fine' => 'wyfhover@163.com' }
  s.source           = { :git => 'https://github.com/wyfhover/FineKit.git', :tag => s.version }
  s.documentation_url = 'https://www.baidu.com'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.platform = :ios

  s.ios.deployment_target = '12.0'
  
  s.swift_version = ['5']

  s.source_files = 'FineKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FineKit' => ['FineKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.subspec 'Extension' do |ex|
    ex.source_files = 'FineKit/Classes/Extension/*.swift'
  end

  s.subspec 'FileManager' do |fm|
    fm.source_files = 'FineKit/Classes/FileManager/*.swift'
  end

  s.subspec 'LanguageManager' do |lm|
    lm.source_files = 'FineKit/Classes/LanguageManager/*.swift'
  end

  s.subspec 'Tools' do |ts|
    ts.source_files = 'FineKit/Classes/Tools/*.swift'
  end

  s.subspec 'XMLTool' do |xmlt|
    xmlt.source_files = 'FineKit/Classes/XMLTool/*.swift'
  end

end
