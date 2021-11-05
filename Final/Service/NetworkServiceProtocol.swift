//
//  NetworkServiceProtocol.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func sendRequest(company: String)
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}
