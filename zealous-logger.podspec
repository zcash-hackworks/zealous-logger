Pod::Spec.new do |s|
  s.name             = 'zealous-logger'
  s.version          = '1.0.0'
  s.summary          = 'Zealous Logger is a small, simple, discrete but yet enthusiastic logger'


  s.description      = <<-DESC
Zealous Logger is a small, simple, discrete but yet enthusiastic logger. Designed for those who need logs, but not snitches. We acknowledge that Application Logs are needed for troubleshooting and development purposes. That doesn't mean that you should choose between logging and your users' privacy. We believe that Privacy is a Human Right, so logs shouldn't leave your device unless you explicitly want to. We write this small library with that in mind.
                       DESC

  s.homepage         = 'https://github.com/zcash-hackworks/zealous-logger'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Francisco \'Pacu\' Gindre' => 'francisco.gindre@gmail.com' }
  s.source           = { :git => 'https://github.com/zcash-hackworks/zealous-logger', :tag => s.version.to_s }
  

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'Sources/zealous-logger/**/*.{swift}'
  s.swift_version = '5.1'
  s.dependency 'CocoaLumberjack/Swift', '~> 3.7.0'
  s.frameworks = 'OSLog'
  s.test_spec 'Tests' do | test_spec |
      test_spec.source_files = 'Tests/zealous-loggerTests/**/*.{swift}'
      test_spec.dependency 'CocoaLumberjack/Swift', '~> 3.7.0'
  end
end
