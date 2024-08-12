//
//  NoInternetBannerView.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 12/08/2024.
//

import Foundation
import UIKit

class NoInternetBannerView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateBanner(message: String, backgroundColor: UIColor) {
        self.messageLabel.text = message
        self.backgroundColor = backgroundColor
    }
}

