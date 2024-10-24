//
//  SuccessViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 23.10.2024.
//

import UIKit

final class SuccessViewController: UIViewController {
    
    private lazy var successImageView: UIImageView = {
        let image = UIImage(named: "successImage") ?? UIImage()
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = image
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapBackButton), for: .touchDown)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavItems()
    }
    
    private func setupNavItems() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        [successImageView,
         successLabel,
         backButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
}
