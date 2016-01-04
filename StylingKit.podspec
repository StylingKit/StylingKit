#
# Be sure to run `pod lib lint StylingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StylingKit"
  s.version          = "0.1.1"
  s.summary          = "Style your iOS app with CSS, using 100% native code and no webviews." 
  s.description      = <<-DESC
                      StylingKit is an iOS framework that allows you to style your application using stylesheets and a CSS-like syntax. StylingKit lets you build  beautiful applications with less code and more flexibility by using familiar CSS markup to style native controls and components. Free up your team to focus on creating amazing user experiences throughout the design and development cycle.
                       DESC

  s.homepage         = "https://github.com/StylingKit/StylingKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = {
    :type => 'Apache 2.0',
    :text => <<-LICENSE
                  Copyright © 2015 StylingKit Development Team

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
  s.requires_arc = true

  s.default_subspec = 'All'
  s.subspec 'All' do |ss|
    ss.source_files = 'Pod/Classes/**/*'
    ss.resource_bundles = {
      'StylingKit' => ['Pod/Assets/*.png']
    }

    ss.preserve_path = "NOTICE"
    ss.dependency 'StylingKit/Freestyle'
  end

  s.subspec 'Freestyle' do |ss|
    ss.prefix_header_file = "Pod/freestyle/src/pixate-freestyle-Prefix.pch"
    ss.source_files = 'Pod/freestyle/src/**/*.{h,m,c}'
    ss.private_header_files = 'Pod/freestyle/src/**/*.h'
    ss.requires_arc = true
    ss.dependency 'StylingKit/MAFuture'
    ss.dependency 'CocoaLumberjack', '~> 2.2.0'

    ss.frameworks = 'CoreText', 'QuartzCore', 'UIKit', 'Foundation', 'CoreGraphics'
  end

  # This code was moved to subspec as it uses MRR while the rest of the project uses ARC
  s.subspec 'MAFuture' do |ss|
    ss.source_files = 'Pod/freestyle/Third-Party/MAFuture/*.{h,m}'
    ss.private_header_files = 'Pod/freestyle/Third-Party/MAFuture/*.h'
    ss.requires_arc = false
  end

end
