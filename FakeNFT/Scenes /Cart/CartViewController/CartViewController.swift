//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let data = CartEnum.cart
    
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
        label.text = "3 NFT"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "5,34 ETH"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypGreenUniversal
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupViews() {
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
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
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
            
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor, constant: 0)
        ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: {action in
            self.switchActions(style: action.style)
        }))
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: {action in
            self.switchActions(style: action.style)
        }))
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: {action in
            self.switchActions(style: action.style)
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: {action in
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
    
    private func makeGradeImage(grade: Int) -> UIImage? {
        let image = "grade\(grade)"
        return UIImage(named: image)
    }
    
    @objc
    private func didTapSortButton() {
        showAlert()
    }
    
    @objc
    private func didTapforPaymentButton() {
    }
}

extension CartViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.nameNFT.text = data[indexPath.row].name
        cell.priceNFT.text = "\(data[indexPath.row].price) ETH".replacingOccurrences(of: ".", with: ",")
        cell.imageNFT.image = data[indexPath.row].image
        cell.gradeNFT.image = makeGradeImage(grade: data[indexPath.row].grade)
        return cell
    }
}

extension CartViewController: CartTableViewCellDelegate {
    
    func imageListCellDidTapLike(_ cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let deleteViewController = DeleteViewController()
        deleteViewController.dataNft = data[indexPath.row]
        deleteViewController.modalPresentationStyle = .overCurrentContext
        self.present(deleteViewController, animated: true)
    }
}
