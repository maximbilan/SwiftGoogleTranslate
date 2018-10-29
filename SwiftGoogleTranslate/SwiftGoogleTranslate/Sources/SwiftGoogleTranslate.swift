//
//  SwiftGoogleTranslate.swift
//  SwiftGoogleTranslate
//
//  Created by Maxim on 10/29/18.
//  Copyright © 2018 Maksym Bilan. All rights reserved.
//

import Foundation

/// A helper class for using Google Translate API.
open class SwiftGoogleTranslate {
	
	/// Shared instance.
	static let shared = SwiftGoogleTranslate()

	/// API structure.
	private struct API {
		/// Base Google Translation API url.
		static let base = "https://translation.googleapis.com/language/translate/v2"
		
		/// Languages endpoint.
		struct languages {
			static let method = "GET"
			static let url = API.base + "/languages"
		}
	}
	
	/// Language response structure.
	public struct Language {
		let language: String
		let name: String
	}
	
	/// API key.
	private var apiKey: String!
	/// Default URL session.
	private let session = URLSession(configuration: .default)
	
	/**
		Initialization
	
		- Parameters:
			- apiKey: A valid API key to handle requests for this API. If you are using OAuth 2.0 service account credentials (recommended), do not supply this parameter.
	*/
	func start(with apiKey: String) {
		self.apiKey = apiKey
	}
	
	/**
		Returns a list of supported languages for translation.
	
		- Parameters:
			- target: The target language code for the results. If specified, then the language names are returned in the name field of the response, localized in the target language. If you do not supply a target language, then the name field is omitted from the response and only the language codes are returned.
			- model: The translation model of the supported languages. Can be either base to return languages supported by the Phrase-Based Machine Translation (PBMT) model, or nmt to return languages supported by the Neural Machine Translation (NMT) model. If omitted, then all supported languages are returned. Languages supported by the NMT model can only be translated to or from English (en).
			- completion: A completion closure with an array of Language structures and an error if there is.
	*/
	func languages(_ target: String = "en", _ model: String = "base", _ completion: @escaping ((_ languages: [Language]?, _ error: Error?) -> Void)) {
		guard var urlComponents = URLComponents(string: API.languages.url) else {
			completion(nil, nil)
			return
		}
		
		var queryItems = [URLQueryItem]()
		queryItems.append(URLQueryItem(name: "key", value: apiKey))
		queryItems.append(URLQueryItem(name: "target", value: target))
		queryItems.append(URLQueryItem(name: "model", value: model))
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			completion(nil, nil)
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = API.languages.method
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data,                            // is there data
				let response = response as? HTTPURLResponse,  // is there HTTP response
				(200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
				error == nil else {                           // was there no error, otherwise ...
				completion(nil, error)
				return
			}
			
			guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let languages = d["languages"] as? [[String: String]] else {
				completion(nil, error)
				return
			}
			
			var result = [Language]()
			for language in languages {
				if let code = language["language"], let name = language["name"] {
					result.append(Language(language: code, name: name))
				}
			}
			completion(result, nil)
		}
		task.resume()
	}
	
}
