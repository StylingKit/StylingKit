#
# Be sure to run `pod lib lint StylingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StylingKit"
  s.version          = "0.4.1"
  s.summary          = "Style your iOS app with CSS, using 100% native code and no webviews." 
  s.description      = <<-DESC
                      StylingKit is an iOS framework that allows you to style your application using stylesheets and a CSS-like syntax. StylingKit lets you build  beautiful applications with less code and more flexibility by using familiar CSS markup to style native controls and components. Free up your team to focus on creating amazing user experiences throughout the design and development cycle.
                       DESC

  s.homepage         = "https://github.com/StylingKit/StylingKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = {
    :type => 'Apache 2.0',
    :text => <<-LICENSE
                  Copyright © 2015-present StylingKit Development Team

                  Licensed under the Apache License, Version 2.0 (the "License");
                  you may not use this file except in compliance with the License.
                  You may obtain a copy of the License at

                      http://www.apache.org/licenses/LICENSE-2.0

                  Unless required by applicable law or agreed to in writing, software
                  distributed under the License is distributed on an "AS IS" BASIS,
                  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                  See the License for the specific language governing permissions and
                  limitations under the License.
                LICENSE
  }
  s.author           = { "Anton Matosov" => "anton.matosov@gmail.com" }
  s.source           = { :git => "https://github.com/StylingKit/StylingKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.1'
  
  s.default_subspec = 'Main'
  s.subspec 'Main' do |ss|
    ss.source_files = 'Pod/Classes/Main/**/*.{h,m,c}'

    ss.preserve_path = "NOTICE"
    ss.dependency 'StylingKit/Freestyle'

    ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => "STK_VERSION=\"#{s.version.to_s}\"" }
  end

  s.subspec 'Freestyle' do |ss|
    ss.prefix_header_file = "Pod/Classes/freestyle/src/pixate-freestyle-Prefix.pch"
    ss.source_files = 'Pod/Classes/freestyle/src/**/*.{h,m,c}'
    ss.private_header_files = 'Pod/Classes/freestyle/src/**/*.h'
  
    ss.frameworks = 'CoreText', 'QuartzCore', 'UIKit', 'Foundation', 'CoreGraphics'
  end

  s.subspec 'WithLogging' do |ss|
    ss.dependency 'StylingKit/Main'

    ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'STK_LOGGING=1' }
    ss.dependency 'CocoaLumberjack', '~> 3.0'
  end

  s.subspec 'Cloud' do |ss|
    ss.subspec 'Main' do |sss|
      sss.dependency 'StylingKit/Main'
      sss.source_files = 'Pod/Classes/Cloud/**/*.{h,m,c}'
      sss.dependency 'GCDWebServer/WebDAV', '~> 3'

      sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'STK_CLOUD=1' }
    end

    ss.subspec 'WithLogging' do |sss|
      sss.dependency 'StylingKit/Cloud/Main'
      sss.dependency 'StylingKit/WithLogging'
      sss.dependency 'GCDWebServer/WebDAV/CocoaLumberjack', '~> 3'
    end
  end
end
