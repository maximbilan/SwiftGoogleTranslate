//
//  SwiftGoogleTranslate.swift
//  SwiftGoogleTranslate
//
//  Created by Maxim on 10/29/18.
//  Copyright © 2018 Maksym Bilan. All rights reserved.
//

import Foundation

/// A helper class for using Google Translate API.
public class SwiftGoogleTranslate {
	
	/// Shared instance.
	public static let shared = SwiftGoogleTranslate()

	/// Language response structure.
	public struct Language {
		public let language: String
		public let name: String
	}
	
	/// Detect response structure.
	public struct Detection {
		public let language: String
		public let isReliable: Bool
		public let confidence: Float
	}
	
	/// API structure.
	private struct API {
		/// Base Google Translation API url.
		static let base = "https://translation.googleapis.com/language/translate/v2"
		
		/// A translate endpoint.
		struct translate {
			static let method = "POST"
			static let url = API.base
		}
		
		/// A detect endpoint.
		struct detect {
			static let method = "POST"
			static let url = API.base + "/detect"
		}
		
		/// A list of languages endpoint.
		struct languages {
			static let method = "GET"
			static let url = API.base + "/languages"
		}
	}
	
	/// API key.
	private var apiKey: String!
	/// Default URL session.
	private let session = URLSession(configuration: .default)
	
	/**
		Initialization.
	
		- Parameters:
			- apiKey: A valid API key to handle requests for this API. If you are using OAuth 2.0 service account credentials (recommended), do not supply this parameter.
	*/
	public func start(with apiKey: String) {
		self.apiKey = apiKey
	}
	
	/**
		Translates input text, returning translated text.
	
		- Parameters:
			- q: The input text to translate. Repeat this parameter to perform translation operations on multiple text inputs.
			- target: The language to use for translation of the input text.
			- format: The format of the source text, in either HTML (default) or plain-text. A value of html indicates HTML and a value of text indicates plain-text.
			- source: The language of the source text. If the source language is not specified, the API will attempt to detect the source language automatically and return it within the response.
			- model: The translation model. Can be either base to use the Phrase-Based Machine Translation (PBMT) model, or nmt to use the Neural Machine Translation (NMT) model. If omitted, then nmt is used. If the model is nmt, and the requested language translation pair is not supported for the NMT model, then the request is translated using the base model.
	*/
	public func translate(_ q: String, _ target: String, _ source: String, _ format: String = "text", _ model: String = "base", _ completion: @escaping ((_ text: String?, _ error: Error?) -> Void)) {
		guard var urlComponents = URLComponents(string: API.translate.url) else {
			completion(nil, nil)
			return
		}
		
		var queryItems = [URLQueryItem]()
		queryItems.append(URLQueryItem(name: "key", value: apiKey))
		queryItems.append(URLQueryItem(name: "q", value: q))
		queryItems.append(URLQueryItem(name: "target", value: target))
		queryItems.append(URLQueryItem(name: "source", value: source))
		queryItems.append(URLQueryItem(name: "format", value: format))
		queryItems.append(URLQueryItem(name: "model", value: model))
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			completion(nil, nil)
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = API.translate.method
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data,								// is there data
				let response = response as? HTTPURLResponse,	// is there HTTP response
				(200 ..< 300) ~= response.statusCode,			// is statusCode 2XX
				error == nil else {								// was there no error, otherwise ...
					completion(nil, error)
					return
			}
			
			guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let translations = d["translations"] as? [[String: String]], let translation = translations.first, let translatedText = translation["translatedText"] else {
				completion(nil, error)
				return
			}
			
			completion(translatedText, nil)
		}
		task.resume()
	}
	
	/**
		Detects the language of text within a request.
	
		- Parameters:
			- q: The input text upon which to perform language detection. Repeat this parameter to perform language detection on multiple text inputs.
	*/
	public func detect(_ q: String, _ completion: @escaping ((_ languages: [Detection]?, _ error: Error?) -> Void)) {
		guard var urlComponents = URLComponents(string: API.detect.url) else {
			completion(nil, nil)
			return
		}
		
		var queryItems = [URLQueryItem]()
		queryItems.append(URLQueryItem(name: "key", value: apiKey))
		queryItems.append(URLQueryItem(name: "q", value: q))
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			completion(nil, nil)
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = API.detect.method
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data,								// is there data
				let response = response as? HTTPURLResponse,	// is there HTTP response
				(200 ..< 300) ~= response.statusCode,			// is statusCode 2XX
				error == nil else {								// was there no error, otherwise ...
					completion(nil, error)
					return
			}
			
			guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let detections = d["detections"] as? [[[String: Any]]] else {
				completion(nil, error)
				return
			}
			
			var result = [Detection]()
			for languageDetections in detections {
				for detection in languageDetections {
					if let language = detection["language"] as? String, let isReliable = detection["isReliable"] as? Bool, let confidence = detection["confidence"] as? Float {
						result.append(Detection(language: language, isReliable: isReliable, confidence: confidence))
					}
				}
			}
			completion(result, nil)
		}
		task.resume()
	}
	
	/**
		Returns a list of supported languages for translation.
	
		- Parameters:
			- target: The target language code for the results. If specified, then the language names are returned in the name field of the response, localized in the target language. If you do not supply a target language, then the name field is omitted from the response and only the language codes are returned.
			- model: The translation model of the supported languages. Can be either base to return languages supported by the Phrase-Based Machine Translation (PBMT) model, or nmt to return languages supported by the Neural Machine Translation (NMT) model. If omitted, then all supported languages are returned. Languages supported by the NMT model can only be translated to or from English (en).
			- completion: A completion closure with an array of Language structures and an error if there is.
	*/
	public func languages(_ target: String = "en", _ model: String = "base", _ completion: @escaping ((_ languages: [Language]?, _ error: Error?) -> Void)) {
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
			guard let data = data,								// is there data
				let response = response as? HTTPURLResponse,	// is there HTTP response
				(200 ..< 300) ~= response.statusCode,			// is statusCode 2XX
				error == nil else {								// was there no error, otherwise ...
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
