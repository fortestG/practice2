//
//  QuoteComponentView.swift
//  Final
//
//  Created by Grigory Khaykin on 05.11.2021.
//

import Foundation
import UIKit
import SnapKit

private extension QuoteComponentView {
    struct Appearance {
        let height: CGFloat = 20
    }
}

final class QuoteComponentView: UIView {
    private let appearance = Appearance()
    
    let title = UILabel()
    let descriptionLabel = UILabel()
    
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
    
    //MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(title)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(appearance.height)
        }
        
        title.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    private func configure() {
        self.backgroundColor = .white
        descriptionLabel.text =  "-"
    }
}

