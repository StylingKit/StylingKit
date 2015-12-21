# StylingKit

[![CI Status](http://img.shields.io/travis/StylingKit/StylingKit.svg?style=flat)](https://travis-ci.org/StylingKit/StylingKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<!---
[![Version](https://img.shields.io/cocoapods/v/StylingKit.svg?style=flat)](http://cocoapods.org/pods/StylingKit)
[![License](https://img.shields.io/cocoapods/l/StylingKit.svg?style=flat)](http://cocoapods.org/pods/StylingKit)
[![Platform](https://img.shields.io/cocoapods/p/StylingKit.svg?style=flat)](http://cocoapods.org/pods/StylingKit))
-->

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
### CocoaPods

StylingKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "StylingKit", :git => "https://github.com/StylingKit/StylingKit"
```

### Carthage

StylingKit is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```
github "StylingKit/StylingKit"
```

### Integrating with your app
Integration is super simple. You don't need to do anything if you are using CocoaPods with frameworks enabled or Carthage.

If you use Objective-C and CocoaPods without frameworks you will have to add the following lines to your `AppDelegate.m`:

```
#import <StylingKit/StylingKit.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[StylingKit sharedKit] startStyling];
}

```
### Add stylesheet

The last, but not least required step is to add stylesheet to your app. The default stylesheet is `default.css` and will be loaded from your app's main bundle automatically. For more information on how to defile `default.css` see [Styling Reference][].

## Styling Reference

StylingKit uses Pixate Freestyle internally, and so far style handling is 100% compatible. You can reference [pixate-freestyle-ios/style-reference](http://pixate.github.io/pixate-freestyle-ios/////style-reference/index.html) for now.

Please keep in mind that while StylingKit evolves it may become incomaptible with original Pixate Freestyle. This page will always reflect the most recent documentation links.

## Discussions, Help and Support

All discussion are happening on the [public Slack channel](https://stylingkit.slack.com).

## Author

Anton Matosov, anton.matosov@gmail.com

## License

Except as otherwise noted, StylingKit is licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html). See the LICENSE file for more info.

More information on the Apache License can be found here: [http://www.apache.org/foundation/license-faq.html](http://www.apache.org/foundation/license-faq.html)

### NOTICE

StylingKit includes modified version of Pixate Freestyle library developed by Pixate, Inc.

## Disclaimer

StylingKit is not affiliated with Pixate Inc. Pixate Freestyle and all other Pixate product names are trademarks or registered trademarks of Pixate Inc. All other company and product names are trademarks or registered trademarks of their respective companies.