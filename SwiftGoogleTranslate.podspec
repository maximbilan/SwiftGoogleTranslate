Pod::Spec.new do |s|
s.name         = "SwiftGoogleTranslate"
s.version      = "0.2.1"
s.summary      = "SwiftGoogleTranslate"
s.description  = "A framework to use Cloud Translation API by Google"
s.homepage     = "https://github.com/maximbilan/SwiftGoogleTranslate"
s.license      = { :type => "MIT" }
s.author       = { "Maxim Bilan" => "maximb.mail@gmail.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/maximbilan/SwiftGoogleTranslate.git", :tag => s.version.to_s }
s.source_files = "Classes", "SwiftGoogleTranslate/Sources/**/*.{swift}"
s.requires_arc = true
end