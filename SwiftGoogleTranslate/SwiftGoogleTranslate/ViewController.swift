//
//  ViewController.swift
//  SwiftGoogleTranslate
//
//  Created by Maxim on 10/29/18.
//  Copyright © 2018 Maksym Bilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		/// Translates a text.
		SwiftGoogleTranslate.shared.translate("Hello!", "es", "en") { (text, error) in
			if let t = text {
				print(t)
			}
		}
		
		/// Detects a language.
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
		
		/// Prints available languages.
		SwiftGoogleTranslate.shared.languages { (languages, error) in
			if let languages = languages {
				for language in languages {
					print(language.language)
					print(language.name)
					print("---")
				}
			}
		}
	}

}
