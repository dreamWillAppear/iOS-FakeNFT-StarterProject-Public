//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import UIKit

class StarRatingView: UIView {

    private var starButtons: [UIImageView] = []
    private let maxStars = 5
    private let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setStars(rating: Int) {
        for (index, button) in starButtons.enumerated() {
            button.image = index > rating ? UIImage(named: "emptyRatingStar") : UIImage(named: "fullRatingStar")
        }
    }
    
    private func setupView() {
        setupStackView()
        setupStars()
        
        setupConstraints()
    }
    
    private func setupStackView() {
        
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStars() {
        for _ in 0..<maxStars {
            let button = UIImageView()
            button.image = UIImage(named: "emptyRatingStar")
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
