//
//  RatingTableViewCell.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.
//


import UIKit
import Kingfisher

class RatingTableViewCell: UITableViewCell {

    private let placeholder = UIImage(systemName: "person.crop.circle.fill")

    private let nameTextLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    private let positionTextLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let scoreTextLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.segmentActive
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    private let profileImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = UIColor(hexString: "#625C5C")
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        return image
    }()

    private let grayBlock = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.segmentInactive
        return view
    }()

    private func addSubViews() {
        contentView.addSubview(grayBlock)
        contentView.addSubview(positionTextLabel)
        grayBlock.addSubview(nameTextLabel)
        grayBlock.addSubview(scoreTextLabel)
        grayBlock.addSubview(profileImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            positionTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            positionTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 30),
            positionTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            positionTextLabel.trailingAnchor.constraint(equalTo: grayBlock.leadingAnchor,constant: -8),

            grayBlock.topAnchor.constraint(equalTo: contentView.topAnchor),
            grayBlock.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            grayBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            grayBlock.leadingAnchor.constraint(equalTo: positionTextLabel.trailingAnchor,constant: 8),
            grayBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            profileImageView.leadingAnchor.constraint(equalTo: grayBlock.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: grayBlock.topAnchor, constant: 26),
            profileImageView.bottomAnchor.constraint(equalTo: grayBlock.bottomAnchor, constant: -26),
            profileImageView.trailingAnchor.constraint(equalTo: nameTextLabel.leadingAnchor, constant: -8),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.widthAnchor.constraint(equalToConstant: 28),

            nameTextLabel.topAnchor.constraint(equalTo: grayBlock.topAnchor, constant: 26),
            nameTextLabel.bottomAnchor.constraint(equalTo: grayBlock.bottomAnchor, constant: -26),
            nameTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameTextLabel.trailingAnchor.constraint(equalTo: scoreTextLabel.leadingAnchor, constant: -16),

            scoreTextLabel.topAnchor.constraint(equalTo: grayBlock.topAnchor, constant: 26),
            scoreTextLabel.bottomAnchor.constraint(equalTo: grayBlock.bottomAnchor, constant: -26),
            scoreTextLabel.trailingAnchor.constraint(equalTo: grayBlock.trailingAnchor, constant: -16),
            scoreTextLabel.leadingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor, constant: 16)
        ])
    }

    private func setupImage(imageString: String) {
        guard let url = URL(string: imageString) else {
            profileImageView.image = placeholder
            profileImageView.tintColor = UIColor(hexString: "#625C5C")
            return
        }
        profileImageView.kf.setImage(with: url, placeholder: placeholder)
    }

    private func setupView(position: Int, score: Int, name: String, imageString: String) {
        addSubViews()
        setupConstraints()
        setupImage(imageString: imageString)

//        contentView.backgroundColor = UIColor.lightGray

        scoreTextLabel.text = "\(score)"
        nameTextLabel.text = name
        positionTextLabel.text = "\(position)"
    }

    func setupCell(position: Int, score: Int, name: String, imageString: String) {
        setupView(position: position, score: score, name: name, imageString: imageString)
    }

}
