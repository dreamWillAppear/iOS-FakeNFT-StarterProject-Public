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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<maxStars {
            let button = UIImageView()
//            button.setImage(UIImage(named: "emptyRatingStar"), for: .normal)
//            button.setImage(UIImage(named: "fullRatingStar"), for: .selected)
//            button.tintColor = .systemYellow
//            button.backgroundColor = .white
            button.image = UIImage(named: "emptyRatingStar")
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setStars(rating: Int) {
        for (index, button) in starButtons.enumerated() {
            button.image = index > rating ? UIImage(named: "emptyRatingStar") : UIImage(named: "fullRatingStar")
        }
    }
}
