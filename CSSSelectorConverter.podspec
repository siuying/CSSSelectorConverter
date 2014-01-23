Pod::Spec.new do |s|
  s.name     = 'CSSSelectorConverter'
  s.version  = '1.1.0'
  s.license  = 'MIT'
  s.summary  = 'Objective-C/Cocoa String Tokenizer and Parser toolkit. Supports Grammars.'
  s.homepage = 'https://github.com/siuying/CSSSelectorConverter'
  s.author   = { 'Francis Chong' => 'francis@ignition.hk' }

  s.source   = { :git => 'https://github.com/siuying/CSSSelectorConverter.git', :tag => '1.1.0', :submodules => true}

  s.description = %{
    A CSS Selector to XPath Selector for Objective-C. Support mostly used subset of CSS Selector Level 3.
  }

  s.ios.deployment_target  = '6.0'
  s.osx.deployment_target  = '10.8'

  s.dependency 'CocoaLumberjack', '>= 1.6.4'
  s.requires_arc           =  true

  s.subspec 'Core' do |ss|
    ss.dependency 'CSSSelectorConverter/CoreParse'
    ss.source_files           = 'CSSSelectorConverter/CSS*.{m,h}'
    ss.prefix_header_contents = "#import \"CSSSelectorConverter.h\""

    # the grammar and the serialized parser
    ss.resources              = 'CSSSelectorConverter/*.{txt,plist}'
  end

  # Use the submodule version of CoreParse
  s.subspec 'CoreParse' do |ss|
    ss.requires_arc   = false
    ss.source_files   = 'vendor/CoreParse/CoreParse/**/*.{h,m}'
    ss.public_header_files   = 'vendor/CoreParse/CoreParse/**/*.{h}'
    ss.osx.frameworks = 'Cocoa'
    ss.ios.frameworks = 'Foundation'
    ss.requires_arc   = false
  end
end