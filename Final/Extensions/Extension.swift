//
//  Extension.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation
import UIKit

extension UIImageView {

	// Загрузка картинок по url
	func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.image = image
			}
		}.resume()
	}
}
