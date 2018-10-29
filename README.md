## SwiftGoogleTranslate

[![Version](https://img.shields.io/cocoapods/v/SwiftGoogleTranslate.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGoogleTranslate)
[![License](https://img.shields.io/cocoapods/l/SwiftGoogleTranslate.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGoogleTranslate)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGoogleTranslate.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGoogleTranslate)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SwiftGoogleTranslate.svg)](https://cocoapods.org/pods/SwiftGoogleTranslate)

A framework to use <a href="https://cloud.google.com/translate/docs/reference/rest">Cloud Translation API by Google</a> in Swift.

## Installation
<b>CocoaPods:</b>
<pre>
pod 'SwiftGoogleTranslate'
</pre>
<b>Manual:</b>
<pre>
Copy <i>SwiftGoogleTranslate.swift</i> to your project.
</pre>

## Initialization

First of all you have to generate API key to use Google Cloud services in the <a href="https://cloud.google.com/translate/">console</a>.
And then use the following code:
<pre>
SwiftGoogleTranslate.shared.start(with: "API_KEY_HERE")
</pre>

## Using

The framework supports 3 endpoinds: <i>translate</i>, <i>detect</i>, <i>languages</i>. You can find more information in the official source. How to use from the framework.

Translation:
<pre>
SwiftGoogleTranslate.shared.translate("Hello!", "es", "en") { (text, error) in
  if let t = text {
    print(t)
  }
}
</pre>

Detection:
<pre>
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
</pre>

A list of languages:
<pre>
SwiftGoogleTranslate.shared.languages { (languages, error) in
  if let languages = languages {
    for language in languages {
      print(language.language)
      print(language.name)
      print("---")
    }
  }
}
</pre>

## License

<i>SwiftGoogleTranslate</i> is available under the MIT license. See the LICENSE file for more info.
