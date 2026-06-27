## SwiftGoogleTranslate

[![Version](https://img.shields.io/cocoapods/v/SwiftGoogleTranslate.svg?style=flat)](https://cocoapods.org/pods/SwiftGoogleTranslate)
[![License](https://img.shields.io/cocoapods/l/SwiftGoogleTranslate.svg?style=flat)](https://cocoapods.org/pods/SwiftGoogleTranslate)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGoogleTranslate.svg?style=flat)](https://cocoapods.org/pods/SwiftGoogleTranslate)

A framework to use [Cloud Translation API by Google](https://cloud.google.com/translate/docs/reference/rest) in Swift.
:snowman::frog::penguin::whale::turtle:

## Installation

**CocoaPods:**

```ruby
pod 'SwiftGoogleTranslate'
```

**Carthage:**

```
github "maximbilan/SwiftGoogleTranslate"
```

**Swift Package Manager:**

```swift
dependencies: [
    .package(url: "https://github.com/maximbilan/SwiftGoogleTranslate", from: "0.2.1")
]
```

**Manual:**

Copy `SwiftGoogleTranslate.swift` to your project.

## Initialization

First of all you have to generate an API key to use Google Cloud services in the [console](https://cloud.google.com/translate/). Then use the following code:

```swift
SwiftGoogleTranslate.shared.start(with: "API_KEY_HERE")
```

## Using

The framework supports 3 endpoints: `translate`, `detect`, and `languages`. You can find more information in the [official documentation](https://cloud.google.com/translate/docs/reference/rest).

Translation:

```swift
SwiftGoogleTranslate.shared.translate("Hello!", "es", "en") { (text, error) in
  if let t = text {
    print(t)
  }
}
```

Detection:

```swift
SwiftGoogleTranslate.shared.detect("¡Hola!") { (detections, error) in
  if let detections = detections {
    for detection in detections {
      print(detection.language)
      print(detection.isReliable)
      print(detection.confidence)
      print("---")
    }
  }
}
```

A list of languages:

```swift
SwiftGoogleTranslate.shared.languages { (languages, error) in
  if let languages = languages {
    for language in languages {
      print(language.language)
      print(language.name)
      print("---")
    }
  }
}
```

## License

`SwiftGoogleTranslate` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
