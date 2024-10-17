//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 16.10.2024.
//

import UIKit

final class MyNFTViewController: UIViewController, MyNFTViewProtocol {
    
    var presenter: MyNFTPresenterProtocol?
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .ypBlack
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Мои NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.tintColor = .ypBlack
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        presenter = MyNFTPresenter(view: self)
        presenter?.loadNFTs()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        setupTable()
        addSubViews()
        applyConstraints()
    }
    
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTCell")
    }
    
    private func addSubViews() {
        [nameLabel, backButton, sortButton, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            
            sortButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.heightAnchor.constraint(equalToConstant: 44),
            sortButton.widthAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.nfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCell", for: indexPath) as! NFTTableViewCell
        if let nft = presenter?.nfts[indexPath.row] {
            cell.configure(
                image: UIImage(named: nft.imageName),
                likeImage: UIImage(named: nft.likeImageName),
                name: nft.name,
                starImage: UIImage(named: nft.ratingImageName),
                author: nft.author,
                price: nft.price
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
