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
		
		// Translates a text.
		SwiftGoogleTranslate.shared.translate("Hello!", "es", "en") { (text, error) in
			if let t = text {
				print(t)
			}
		}
		
		/// Prints available languages.
//		SwiftGoogleTranslate.shared.languages { (languages, error) in
//			if let languages = languages {
//				for language in languages {
//					print(language.language)
//					print(language.name)
//					print("---")
//				}
//			}
//		}
		
		
	}

}
