require 'rubygems'
require 'rake'

desc "Run tests"
task :test do
  system("xcodebuild -workspace CSSSelectorConverter.xcworkspace -scheme CSSSelectorConverter -sdk iphonesimulator test")
end