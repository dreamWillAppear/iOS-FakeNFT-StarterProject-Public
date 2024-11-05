//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    var presenter: PaymentViewPresenterProtocol? { get set }
    func presentResultOfPay(isSuccess: Bool)
}

protocol SuccessPaymentDelegate: AnyObject {
    func orderOfNftIsEmpty(orderIsEmpty: Bool)
}

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    
    var presenter: PaymentViewPresenterProtocol?
    var delegate: SuccessPaymentDelegate?
    
    private var paymentId: String?
    private var paymentServiceObserver: NSObjectProtocol?
    
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

    private lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var agreementButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapTextView), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapPaymentButton), for: .touchUpInside)
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
        presenter = PaymentViewPresenter(view: self)
        presenter?.fetchPayment()
        setupNavItems()
        setupViews()
        setupDelegates()
        paymentServiceObserver = NotificationCenter.default
            .addObserver(
                forName: PaymentService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    collectionView.reloadData()
                }
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
         agreementLabel,
         agreementButton].forEach{
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
            
            agreementLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            agreementLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            
            agreementButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 0),
            agreementButton.leadingAnchor.constraint(equalTo: agreementLabel.leadingAnchor)
        ])
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
    
    private func isSelectedCell(cell: PaymentCollectionViewCell?, isSelected: Bool) {
        if isSelected {
            cell?.containerView.layer.borderWidth = 1
            cell?.containerView.layer.borderColor = UIColor.ypBlack?.cgColor
        } else {
            cell?.containerView.layer.borderWidth = 0
            cell?.containerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func presentResultOfPay(isSuccess: Bool) {
        if isSuccess {
            let successViewController = SuccessViewController()
            delegate?.orderOfNftIsEmpty(orderIsEmpty: true)
            navigationController?.pushViewController(successViewController, animated: true)
        } else {
            showAlert()
        }
    }
    
    @objc
    private func didTapPaymentButton() {
        guard let paymentId = self.paymentId else { return }
        presenter?.fetchPay(paymentId: paymentId)
    }
    
    @objc
    private func didTapTextView() {
        let webView = WebViewController()
        webView.modalPresentationStyle = .automatic
        self.present(webView, animated: true)
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        self.isSelectedCell(cell: cell, isSelected: true)
        guard let id = cell?.paymentId else { return }
        self.paymentId = id
        paymentButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        self.isSelectedCell(cell: cell, isSelected: false)
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let payment = presenter?.paymentData else { return 0 }
        return payment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentCollectionViewCell.identifier,
            for: indexPath
        ) as? PaymentCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let payment = presenter?.paymentData else { return UICollectionViewCell() }
        cell.paymentName.text = payment[indexPath.row].title
        cell.paymentShortName.text = payment[indexPath.row].name
        let urlString = payment[indexPath.row].image
        let url = URL(string: urlString)
        cell.paymentImage.kf.setImage(with: url)
        cell.paymentId = payment[indexPath.row].id
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 7) / 2
        let height: CGFloat = width * 0.27
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
