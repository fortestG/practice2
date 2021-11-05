//
//  ViewController.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import UIKit

protocol ViewInputProtocol {
    func updateDisplayData(company: String,
                           symbol: String,
                           price: Double,
                           priceChange: Double,
                           logoURL: URL)
    func resetView()
    func showAlert()
}

class ViewController: UIViewController {
    private var networkService: NetworkServiceProtocol?
    private let customView = QuoteView()
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var priceChange: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    
    private let companies: [String: String] = ["Apple": "AAPL", "Microsoft": "MCRSFT", "Google": "GOOG", "Amazon": "AMZN", "Facebook": "FB"]
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networkService = NetworkService(vc: self)
        customView.backgroundColor = .gray
        self.customView.companyPickerView.dataSource = self
        self.customView.companyPickerView.delegate = self
        self.customView.activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
    }
    
    private func requestQuoteUpdate() {
        self.customView.activityIndicator.startAnimating()
        let selectedRow = self.customView.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.networkService?.sendRequest(company: selectedSymbol)
    }
    
    private func downloadImage(from url: URL) {
        networkService!.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.customView.companyLogo.image = UIImage(data: data)
            }
        }
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.customView.activityIndicator.startAnimating()
        let selectedSymbol = Array(self.companies.values)[row]
        self.networkService?.sendRequest(company: selectedSymbol)
    }
}

extension ViewController: UIPickerViewDelegate {
    
}


extension ViewController: ViewInputProtocol {
    func updateDisplayData(company: String,
                           symbol: String,
                           price: Double,
                           priceChange: Double,
                           logoURL: URL) {
        self.customView.activityIndicator.stopAnimating()
        self.customView.updateView(company: company,
                                   symbol: symbol,
                                   price: price,
                                   priceChange: priceChange,
                                   logoURL: logoURL)
        downloadImage(from: logoURL)
    }
    
    func resetView() {
        self.customView.resetView()
    }
    
    func showAlert() {
        let alertVC = UIAlertController(
            title: "Error",
            message: "Something went wrong",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}

