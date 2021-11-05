//
//  ViewController.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import UIKit

class ViewController: UIViewController {
	
    private var networkService: NetworkServiceProtocol?
	var quote: QuoteModel?
    private let customView = QuoteView()
	var selectedRow: Int?
	var selectedSymbol: String?

    private let companies: [String: String] = ["Apple": "AAPL", "Microsoft": "MCRSFT", "Google": "GOOG", "Amazon": "AMZN", "Facebook": "FB"]
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		networkService = NetworkService()
        customView.backgroundColor = .white
        self.customView.companyPickerView.dataSource = self
        self.customView.companyPickerView.delegate = self
        self.customView.activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
    }
    
    private func requestQuoteUpdate() {
        self.customView.activityIndicator.startAnimating()
		self.selectedRow = self.customView.companyPickerView.selectedRow(inComponent: 0)
		self.selectedSymbol = Array(self.companies.values)[selectedRow ?? 0]
		resetView()
		self.networkService?.loadQuote(for: selectedSymbol ?? "") { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let model):
				DispatchQueue.main.async {
					self.customView.activityIndicator.stopAnimating()
					guard let change = model.change,
						  let price = model.latestPrice,
						  let symbol = model.symbol,
						  let companyName = model.companyName
					else { return }
					self.customView.updateView(company: companyName,
											   symbol: symbol,
											   price: price,
											   priceChange: change
					)
				}
				case .failure(let error):
				self.handle(error: error)
			}
		}
    }
	
	func resetView() {
		self.customView.resetView()
	}
	
	func handle(error: CustomErrors) {
		switch error {
		case .UnknownError:
			DispatchQueue.main.async {
				self.showAlert(title: "Errow", message: "Somthing went wrong!")
			}
		}
	}

	func showAlert(title: String, message: String) {
		let alertVC = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertVC.addAction(action)
		self.present(alertVC, animated: true, completion: nil)
	}
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
}

extension ViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Array(self.companies.keys)[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.customView.activityIndicator.startAnimating()
		self.selectedSymbol = Array(self.companies.values)[row]
		requestQuoteUpdate()
	}
}
