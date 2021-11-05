//
//  QuoteModel.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation

struct QuoteModel: Codable {
	let companyName: String?
	let change: Double?
	let latestPrice: Double?
	let symbol: String?
}
