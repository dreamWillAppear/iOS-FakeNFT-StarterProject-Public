//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    var presenter: CartViewPresenterProtocol? { get set }
}

final class CartViewController: UIViewController, CartViewControllerProtocol {
    
    private var cartServiceObserver: NSObjectProtocol?
    private var nftServiceObserver: NSObjectProtocol?
    
    var presenter: CartViewPresenterProtocol?
    
    let cartService = CartService.shared
    let nftService = NftsService.shared

    
    private var data: CartResult?
    private var arrayOfNfts: [NftResult] = []
    
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "sortIcon") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapSortButton))
        button.backgroundColor = .clear
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var forPaymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapforPaymentButton), for: .touchDown)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var countNFTLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypGreenUniversal
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CartViewPresenter(view: self)
        presenter?.fetchCart()
        setupViews()
        setupNavItems()
        cartServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CartService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    tableView.reloadData()
                }
        nftServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftsService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        [sortButton,
         paymentView,
         tableView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [countNFTLabel,
         priceNFTLabel,
         forPaymentButton].forEach{
            paymentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            paymentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            countNFTLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            countNFTLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            
            priceNFTLabel.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
            priceNFTLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            priceNFTLabel.topAnchor.constraint(equalTo: countNFTLabel.bottomAnchor, constant: 2),
            
            forPaymentButton.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            forPaymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            forPaymentButton.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
            forPaymentButton.leadingAnchor.constraint(equalTo: priceNFTLabel.trailingAnchor, constant: 24),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor, constant: 0)
        ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
        }))
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
        }))
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { [weak self] action in
            guard let self = self else { return }
        }))
        self.present(alert, animated: true)
    }
    
    private func paymentViewIsHidden(bool: Bool) {
        paymentView.isHidden = bool
        forPaymentButton.isHidden = bool
    }
    
    private func setupPaymentLabels() {
        let nfts = nftService.arrayOfNfts
        var price: Double = 0.0
        nfts.forEach{
            price += $0.price
        }
        self.countNFTLabel.text = "\(nfts.count) NFT"
        self.priceNFTLabel.text = "\(String(format: "%.2f", price)) NFT".replacingOccurrences(of: ".", with: ",")
    }
    
    @objc
    private func didTapSortButton() {
        showAlert()
    }
    
    @objc
    private func didTapforPaymentButton() {
        let paymentViewController = PaymentViewController()
        navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

extension CartViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nftService.arrayOfNfts.count != self.data?.nfts.count {
            paymentViewIsHidden(bool: true)
        }
        guard let nfts = presenter?.cardData?.nfts else { return 0 }
        return nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        let nfts = nftService.arrayOfNfts
        if nfts.isEmpty {
            return UITableViewCell()
        }
        if nfts.count - 1 < indexPath.row {
            return UITableViewCell()
        }
        paymentViewIsHidden(bool: false)
        setupPaymentLabels()
        cell.setupCell(nft: nfts[indexPath.row])
        guard let imageUrl = URL(string: nfts[indexPath.row].images[0]) else {
            return cell
        }
        cell.imageNFT.kf.indicatorType = .activity
        cell.imageNFT.kf.setImage(with: imageUrl, placeholder: UIImage()) { result in
            switch result {
            case .success(_):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("[ImagesListViewController]: \(error)")
            }
        }
        return cell
    }
}

extension CartViewController: CartTableViewCellDelegate {
    
    func cartCellDidTapDelete(_ cell: CartTableViewCell) {
        let nfts = nftService.arrayOfNfts
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let deleteViewController = DeleteViewController()
        deleteViewController.dataNft = nfts[indexPath.row]
        deleteViewController.modalPresentationStyle = .overFullScreen
        self.present(deleteViewController, animated: true)
    }
}
