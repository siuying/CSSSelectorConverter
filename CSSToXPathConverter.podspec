Pod::Spec.new do |s|
  s.name     = 'CSSToXPathConverter'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'Objective-C/Cocoa String Tokenizer and Parser toolkit. Supports Grammars.'
  s.homepage = 'https://github.com/siuying/CSSToXPathConverter'
  s.author   = { 'Francis Chong' => 'francis@ignition.hk' }

  s.source   = { :git => 'https://github.com/siuying/CSSToXPathConverter.git', :tag => '1.0.0'}

  s.description = %{
    A CSS Selector to XPath Selector for Objective-C. Support mostly used subset of CSS Selector Level 3.
  }

  s.source_files           =  'CSSSelectorConverter/CSS*.{m,h}'
  s.prefix_header_contents = "#import \"CSSToXPathConverter.h\""

  s.dependency 'ParseKit', '~> 0.7'
  s.library                =  'icucore'
  s.requires_arc           =  true
end