//
//  NetworkServiceProtocol.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation

protocol NetworkServiceProtocol {
	func loadQuote(for symbol: String, completion: @escaping (Result<QuoteModel, CustomErrors>) -> Void)}
