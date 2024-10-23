//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    private let payment = MokeEnum.payment
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var linkTextView: UITextView = {
       let textView = UITextView()
        return textView
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapPaymentButton), for: .touchDown)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PaymentCollectionViewCell.self,
                                forCellWithReuseIdentifier: PaymentCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = true
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        setupViews()
        setupDelegates()
        setupLinkTextView()
    }
    
    private func setupNavItems() {
        navigationItem.titleView = titleLabel
    }
    
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        [paymentView,
         collectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [paymentButton,
         linkTextView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            paymentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            paymentView.heightAnchor.constraint(equalToConstant: 186),
            
            paymentButton.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -12),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: paymentView.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            linkTextView.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            linkTextView.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            linkTextView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            linkTextView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupLinkTextView() {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineSpacing = 4
        titleParagraphStyle.paragraphSpacing = 4
        let attributedString = NSMutableAttributedString(string: "Совершая покупку, вы соглашаетесь с условиями \nПользовательского соглашения")
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        attributedString.setAttributes([.link: url, .paragraphStyle: titleParagraphStyle],
                                       range: NSMakeRange(45, 30))
        self.linkTextView.attributedText = attributedString
        self.linkTextView.textColor = .ypBlack
        self.linkTextView.isUserInteractionEnabled = true
        self.linkTextView.isEditable = false
        self.linkTextView.backgroundColor = .clear
        self.linkTextView.linkTextAttributes = [
            .foregroundColor: UIColor.ypBlueUniversal,
            .font: UIFont.systemFont(ofSize: 13, weight: .regular)
        ]
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Не удалось произвести \nоплату",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.switchActions(style: action.style)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.switchActions(style: action.style)
        }))
        self.present(alert, animated: true)
    }
    
    private func switchActions(style: UIAlertAction.Style) {
        switch style {
        case .default:
            return
        case .cancel:
            return
        case .destructive:
            return
        @unknown default:
            return
        }
    }
    
    @objc
    private func didTapPaymentButton() {
        let isSuccesss = [true, false].randomElement() ?? false
        if isSuccesss {
            let successViewController = SuccessViewController()
            navigationController?.pushViewController(successViewController, animated: true)
        } else {
            showAlert()
        }
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        cell?.containerView.layer.borderWidth = 1
        cell?.containerView.layer.borderColor = UIColor.ypBlack?.cgColor
        paymentButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        cell?.containerView.layer.borderWidth = 0
        cell?.containerView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentCollectionViewCell.identifier,
            for: indexPath
        ) as? PaymentCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = payment[indexPath.row]
        cell.paymentImage.image = index.image
        cell.paymentName.text = index.fullName
        cell.paymentShortName.text = index.shortName
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 7) / 2, height: ((collectionView.frame.width - 7) / 2) * 0.27)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
