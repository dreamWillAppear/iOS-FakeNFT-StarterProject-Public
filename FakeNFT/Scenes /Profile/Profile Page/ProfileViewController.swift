//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 15.10.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var profile: Profile?
    
    private var nftCount = 0
    private var favouriteCount = 0
    
    private var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "editButton"), for: .normal)
        return button
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .caption2
        return label
    }()
    
    private var websiteLink: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption1
        label.textColor = .ypBlueUniversal
        label.isUserInteractionEnabled = true
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        websiteLink.addGestureRecognizer(tapGesture)
        
        presenter = ProfilePresenter(view: self)
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
        tableView.separatorStyle = .none
    }
    
    @objc private func openWebsite() {
        let webVC = WebViewController()
        webVC.modalPresentationStyle = .fullScreen
        present(webVC, animated: true, completion: nil)
    }
    
    func updateProfile(_ profile: Profile) {
        self.profile = profile
        let imageURL = URL(string: profile.avatarImageURL)
        
        avatarImageView.kf.setImage(with: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.avatarImageView.layer.cornerRadius = 34
                    self.avatarImageView.clipsToBounds = true
                    print("Avatar is successfully loaded")
                case .failure(let error):
                    print("[ProfileViewController: avatarImageURL]: Error while loading image.\(error)")
                }
            }
        }
        
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLink.text = profile.website
        nftCount = profile.nfts.count
        favouriteCount = profile.likes.count
    
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Мои NFT (\(nftCount))"
        case 1:
            cell.textLabel?.text = "Избранные NFT (\(favouriteCount))"
        default:
            cell.textLabel?.text = "О разработчике"
        }
        
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
            openWebsite()
        }
    }
}


extension ProfileViewController: EditProfileViewControllerDelegate {
    func didUpdateProfile() {
        presenter?.loadProfileData()
        dismiss(animated: true)
    }
    
    @objc private func editButtonTapped() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.profile = self.profile
        editProfileVC.delegate = self
        
        let popover = UIPopoverPresentationController(presentedViewController: editProfileVC, presenting: self)
        popover.sourceView = self.view
        popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        popover.permittedArrowDirections = []
        
        editProfileVC.modalPresentationStyle = .popover
        present(editProfileVC, animated: true, completion: nil)
    }
}
