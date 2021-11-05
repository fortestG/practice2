//
//  NetworkService.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation
import UIKit

public enum CustomErrors: Error {
   case UnknownError
}

final class NetworkService: NetworkServiceProtocol {
    
    private let decoder = JSONDecoder()
    private let token = "pk_404354cd570b4d2eb7f7aa12e2f525fe"
    private let baseURL = "https://cloud.iexapis.com/stable/stock/"
	
	func loadQuote(for symbol: String, completion: @escaping (Result<QuoteModel, CustomErrors>) -> Void) {
		let token = "pk_a6bf6fdedbf645799b96108665eab932"
		guard
			let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else {
			return
		}
		
		let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
			guard (response as? HTTPURLResponse)?.statusCode == 200,
				  let data = data
			else {
				print("❗️Network error")
				completion(.failure(CustomErrors.UnknownError))
				return
			}
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let quote = try decoder.decode(QuoteModel.self, from: data)
				DispatchQueue.main.async {
					completion(.success(quote))
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(CustomErrors.UnknownError))
				}
			}
		}
		dataTask.resume()
	}
}

