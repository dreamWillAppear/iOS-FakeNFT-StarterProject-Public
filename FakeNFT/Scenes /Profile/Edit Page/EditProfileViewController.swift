//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 15.10.2024.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func didUpdateProfile()
}

final class EditProfileViewController: UIViewController, EditProfileViewProtocol, UITextViewDelegate {

    
    weak var delegate: EditProfileViewControllerDelegate?
    var profile: Profile?
    var presenter: EditProfilePresenterProtocol?
    
    private var avatarURL: String?
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 34
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var darkOverlayView: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .ypBlack?.withAlphaComponent(0.6)
        overlay.layer.cornerRadius = 34
        return overlay
    }()
    
    private var changePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сменить\n фото", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.ypWhiteUniversal, for: .normal)
        return button
    }()
    
    private var changePhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сменить\n фото"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .ypWhiteUniversal
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Имя"
        label.font = .headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private var nameTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Joaquin Phoenix"
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGrey
        textView.font = .bodyRegular
        textView.textColor = .ypBlack
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.font = .headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGrey
        textView.font = .bodyRegular
        textView.textColor = .ypBlack
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }()
    
    private var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сайт"
        label.font = .headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private var websiteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Joaquin Phoenix.com"
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGrey
        textView.font = .bodyRegular
        textView.textColor = .ypBlack
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .ypBlack
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        if presenter == nil {
            presenter = EditProfilePresenter(view: self)
        }
        
        descriptionTextView.delegate = self
        websiteTextView.delegate = self
        
        loadProfile(profile)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        changePhotoButton.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
        
        addSubViews()
        applyConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            saveProfileChanges()
            delegate?.didUpdateProfile()
        }
    }
    
    private func addSubViews() {
        [closeButton, avatarImageView, changePhotoButton, nameLabel, nameTextView, descriptionLabel, descriptionTextView, websiteLabel, websiteTextView].forEach {
            view.addSubview($0)
        }
        avatarImageView.addSubview(darkOverlayView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            darkOverlayView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            darkOverlayView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            changePhotoButton.centerXAnchor.constraint(equalTo: darkOverlayView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: darkOverlayView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextView.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextView.trailingAnchor),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            websiteTextView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextView.leadingAnchor.constraint(equalTo: nameTextView.leadingAnchor),
            websiteTextView.trailingAnchor.constraint(equalTo: nameTextView.trailingAnchor),
        ])
    }
    
    private func loadProfile(_ profile: Profile?) {
        guard let profile = profile else { return }
        updateProfile(profile)
    }
    
    func updateProfile(_ profile: Profile) {
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
        
        nameTextView.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextView.text = profile.website
        avatarURL = profile.avatarImageURL
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    @objc private func saveProfileChanges() {
        guard let name = nameTextView.text,
              let description = descriptionTextView.text,
              let website = websiteTextView.text,
              let avatarURL = self.avatarURL else { return }
        presenter?.saveProfile(name: name, description: description, website: website, avatarURL: avatarURL)
    }
    
    @objc private func closeButtonTapped() {
        saveProfileChanges()
        delegate?.didUpdateProfile()
        //dismiss(animated: true)
    }
    
    @objc private func changePhotoButtonTapped() {
        let alertController = UIAlertController(title: "Аватар", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Введите ссылку на фото"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Готово", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let urlString = textField.text, !urlString.isEmpty,
                  let imageURL = URL(string: urlString) else { return }
            
            self?.avatarImageView.kf.setImage(with: imageURL) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.avatarImageView.layer.cornerRadius = 34
                        self?.avatarImageView.clipsToBounds = true
                        self?.avatarURL = urlString
                        print("Аватар успешно обновлён")
                    case .failure(let error):
                        print("Ошибка при загрузке изображения: \(error)")
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension UITextField {
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
