//
//  QuoteView.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation
import UIKit
import SnapKit

private extension QuoteView {
    struct Appearance {
        let multiplier: CGFloat = 0.3
        let spacing: CGFloat = 40
        let topOffset: CGFloat = 8
        let height: CGFloat = 250
        let sideInsets: CGFloat = 20
        let topImageOffset: CGFloat = 40
        let size: CGSize = CGSize(width: 70, height: 70)
		let companyLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
    }
}

final class QuoteView: UIView {
    private let appearance = Appearance()
    
    let companyPickerView = UIPickerView()
    let activityIndicator = UIActivityIndicatorView()
    let companyLogo = UIImageView()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = appearance.spacing
        return stack
    }()
    
    private let companyView = QuoteComponentView()
    private let priceView = QuoteComponentView()
    private let priceChangeView = QuoteComponentView()
    private let symbolView = QuoteComponentView()

    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(company: String,
                    symbol: String,
                    price: Double,
                    priceChange: Double
	) {
        priceView.descriptionLabel.text = "\(price)"
        companyView.descriptionLabel.text = company
        priceChangeView.descriptionLabel.text = "\(priceChange)"
        symbolView.descriptionLabel.text = symbol
        
        if priceChange > 0 {
            self.priceChangeView.descriptionLabel.textColor = .green
        } else if priceChange < 0 {
            self.priceChangeView.descriptionLabel.textColor = .red
        } else if priceChange == 0 {
            self.priceChangeView.descriptionLabel.textColor = .black
        }
		
		guard let imageUrl = URL(string: "https://storage.googleapis.com/iex/api/logos/\(symbol).png")
			else { return }
		self.companyLogo.downloaded(from: imageUrl)
    }
    
    func resetView() {
        self.companyView.descriptionLabel.text = "_"
        self.symbolView.descriptionLabel.text = "_"
        self.priceView.descriptionLabel.text = "_"
        self.priceChangeView.descriptionLabel.text = "_"
        self.priceChangeView.descriptionLabel.textColor = .black
    }

    
    //MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(stackView)
        addSubview(companyPickerView)
        addSubview(activityIndicator)
        addSubview(companyLogo)
        
        stackView.addArrangedSubview(companyView)
        stackView.addArrangedSubview(symbolView)
        stackView.addArrangedSubview(priceView)
        stackView.addArrangedSubview(priceChangeView)
    }
    
    private func setupConstraints() {
        companyPickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(appearance.multiplier)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        companyLogo.snp.makeConstraints { make in
            make.size.equalTo(appearance.size)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(appearance.topOffset)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(appearance.height)
            make.left.right.equalToSuperview().inset(appearance.sideInsets)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(appearance.topImageOffset)
        }
    }
    
    private func configure() {
        self.backgroundColor = .white
		companyView.descriptionLabel.font = appearance.companyLabelFont
        priceView.title.text = "Price"
        companyView.title.text = "Company name"
        priceChangeView.title.text = "Price Change"
        symbolView.title.text = "Symbol"
    }
}
