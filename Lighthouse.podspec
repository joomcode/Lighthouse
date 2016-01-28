Pod::Spec.new do |s|
  s.name             = "Lighthouse"
  s.version          = "0.2.1"
  s.summary          = "The iOS navigation framework you've been looking for. No more coupled view controllers or magic URL strings!"

  s.homepage         = "https://github.com/pixty/Lighthouse"  
  s.license          = 'MIT'
  s.author           = { "Nick Tymchenko" => "t.nick.a@gmail.com" }
  s.source           = { :git => "https://github.com/pixty/Lighthouse.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nickynick42'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Lighthouse/**/*.{h,m}'
  s.public_header_files = 'Lighthouse/**/*.h'

  s.frameworks = 'UIKit'
end
