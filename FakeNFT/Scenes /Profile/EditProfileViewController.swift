//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 15.10.2024.
//

import UIKit

final class EditProfileViewController: UIViewController, UITextViewDelegate {

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    
    private var darkOverlayView: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .ypBlack?.withAlphaComponent(0.6)
        overlay.layer.cornerRadius = 34
        return overlay
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        descriptionTextView.delegate = self
        websiteTextView.delegate = self
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [avatarImageView, nameLabel, nameTextView, descriptionLabel, descriptionTextView, websiteLabel, websiteTextView].forEach {
            view.addSubview($0)
        }
        avatarImageView.addSubview(darkOverlayView)
        darkOverlayView.addSubview(changePhotoLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            darkOverlayView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            darkOverlayView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            changePhotoLabel.centerXAnchor.constraint(equalTo: darkOverlayView.centerXAnchor),
            changePhotoLabel.centerYAnchor.constraint(equalTo: darkOverlayView.centerYAnchor),
            
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
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
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

