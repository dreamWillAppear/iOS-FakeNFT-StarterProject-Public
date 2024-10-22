//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavItems()
    }
    
    private func setupNavItems() {
        navigationItem.titleView = titleLabel
    }
}
