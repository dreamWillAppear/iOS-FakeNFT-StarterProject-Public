//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

protocol DeleteViewControllerProtocol: AnyObject {
    var presenter: DeleteViewPresenterProtocol? { get set }
    func dismissVC()
    func didDelete()
}

protocol DeleteViewDelegate: AnyObject {
    func didDelete()
}

final class DeleteViewController: UIViewController, DeleteViewControllerProtocol {
    
    var dataNft: NftResult?
    var order: CartResult?
    var presenter: DeleteViewPresenterProtocol?
    var delegate: DeleteViewDelegate?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Вы уверены, что хотите \n удалить объект из корзины?"
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var deleteButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRedUniversal, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapDeleteButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var cancelButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapCancelButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
        self.presenter = DeleteViewPresenter(view: self)
    }
    
    func dismissVC() {
        self.dismiss(animated: true)
    }
    
    func didDelete() {
        delegate?.didDelete()
    }
    
    private func setupViews() {
        guard let imageUrlString = dataNft?.images[0] else { return }
        guard let imageUrl = URL(string: imageUrlString) else { return }
        self.nftImageView.kf.indicatorType = .activity
        self.nftImageView.kf.setImage(with: imageUrl)
        [nftImageView,
         deleteLabel,
         buttonsView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [deleteButton,
         cancelButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            deleteLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            deleteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 262),
            buttonsView.heightAnchor.constraint(equalToConstant: 44),
            buttonsView.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0),
            deleteButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: 0),
            deleteButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            
            cancelButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0),
            cancelButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: 0),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),

        ])
    }
    
    private func setupBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    @objc
    private func didTapDeleteButton() {
        guard let dataNft = dataNft else { return }
        guard let order = order else { return }
        presenter?.fetchDeleteNft(order: order, deletetedNft: dataNft.id)
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
}
