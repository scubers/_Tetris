#
# Be sure to run `pod lib lint Tetris.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Tetris'
  s.version="0.5.5"
  s.summary          = 'A short description of Tetris.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/scubers/_Tetris'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jr-wong' => 'jr-wong@qq.com' }
  s.source           = { :git => 'https://github.com/scubers/_Tetris.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Tetris/Classes/Core/**/*'
  end

  s.subspec 'Swift' do |swift|
    swift.source_files = 'Tetris/Classes/Swift/**/*'
    swift.dependency 'Tetris/Core'
  end
  
  s.swift_version = '5.1'
  
  s.subspec 'Rx' do |rx|
      rx.source_files = 'Tetris/Classes/Rx/**/*'
      rx.dependency 'Tetris/Swift'
      rx.dependency 'RxSwift'
      puts "please specify RxSwift version in your own podfile."
  end

  s.default_subspec = 'Core'

end
