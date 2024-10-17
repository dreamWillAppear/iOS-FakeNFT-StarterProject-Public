//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 15.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    let cellData = [
        "Мои NFT (112)",
        "Избранные NFT",
        "О разработчике"
    ]
    
    private var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "editButton"), for: .normal)
        return button
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joaquin Phoenix"
        label.font = .headline3
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        label.font = .caption2
        return label
    }()
    
    private var websiteLink: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joaquin Phoenix.com"
        label.font = .caption1
        label.textColor = .ypBlueUniversal
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        addSubViews()
        applyConstraints()
        setupTableView()
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        presenter?.loadProfileData()
    }
    
    private func addSubViews() {
        [editButton, avatarImageView, nameLabel, descriptionLabel, websiteLink, tableView].forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 44),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteLink.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLink.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: websiteLink.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 54
    }
    
    func updateProfile(_ profile: Profile) {
        avatarImageView.image = UIImage(named: profile.avatarImageName)
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLink.text = profile.website
    }
    
    @objc private func editButtonTapped() {
        let editProfileVC = EditProfileViewController()
        let popover = UIPopoverPresentationController(presentedViewController: editProfileVC, presenting: self)
        popover.sourceView = self.view
        popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        popover.permittedArrowDirections = []
        
        editProfileVC.modalPresentationStyle = .popover
        present(editProfileVC, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = cellData[indexPath.row]
        cell.textLabel?.font = .bodyBold
        
        let chevronImage = UIImage(systemName: "chevron.right",
                                   withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.tintColor = .black
        cell.accessoryView = chevronImageView
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        switch indexPath.row {
        case 0:
            let myNFTVC = MyNFTViewController()
            myNFTVC.modalPresentationStyle = .fullScreen
            view.window?.layer.add(transition, forKey: kCATransition)
            present(myNFTVC, animated: false, completion: nil)
            
        case 1:
            let favouritesVC = FavouritesViewController()
            favouritesVC.modalPresentationStyle = .fullScreen
            view.window?.layer.add(transition, forKey: kCATransition)
            present(favouritesVC, animated: false, completion: nil)
            
        default:
            break
        }
    }
}
