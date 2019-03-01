#
# Be sure to run `pod lib lint ApproveAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ApproveAPI'
    s.version          = '0.1.0'
    s.summary          = 'ApproveAPI for iOS.'

    s.description      = <<-DESC
    A simple API for iOS to request a user's real-time approval on anything via email, SMS + mobile push.
    DESC
    
    s.homepage         = 'https://github.com/imryan/ApproveAPI'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Ryan Cohen' => 'notryancohen@gmail.com' }
    s.source           = { :git => 'https://github.com/imryan/ApproveAPI.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files = 'ApproveAPI/Classes/**/*'
    s.dependency 'Alamofire'
end
