require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'nabla-react-native-core'
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['repository']
  s.platform     = :ios, "13.0"

  s.source       = { :git => "https://github.com/nabla/nabla-react-native.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/Sources/**/*.{h,m,swift}"

  s.dependency 'React-Core'
  s.dependency 'NablaCore', '1.0.0-alpha28'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files= "ios/Tests/**/*.{h,m,swift}"
  end
end
