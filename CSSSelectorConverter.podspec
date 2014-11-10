Pod::Spec.new do |s|
  s.name     = 'CSSSelectorConverter'
  s.version  = '1.1.4'
  s.license  = 'MIT'
  s.summary  = 'Objective-C/Cocoa String Tokenizer and Parser toolkit. Supports Grammars.'
  s.homepage = 'https://github.com/siuying/CSSSelectorConverter'
  s.author   = { 'Francis Chong' => 'francis@ignition.hk' }

  s.source   = { :git => 'https://github.com/siuying/CSSSelectorConverter.git', :tag => s.version.to_s }

  s.description = %{
    A CSS Selector to XPath Selector for Objective-C. Support mostly used subset of CSS Selector Level 3.
  }

  s.ios.deployment_target  = '6.0'
  s.osx.deployment_target  = '10.8'

  s.dependency 'CocoaLumberjack', '~> 1.9.0'
  s.dependency 'NUIParse'
  s.requires_arc           = true

  s.source_files           = 'CSSSelectorConverter/CSS*.{m,h}'
  s.prefix_header_contents = "#import \"CSSSelectorConverter.h\""
  s.requires_arc           = true
  s.resources              = 'CSSSelectorConverter/*.{txt,plist}'
end
