//
//  RatingTableViewController.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.

import UIKit
import ProgressHUD

protocol RatingTableViewControllerProtocol: AnyObject {
    func reloadData()
    func showSortOptionsAlert()
    func showProgressHud()
    func hideProgressHud()
}

final class RatingTableViewController: UIViewController, RatingTableViewControllerProtocol {
    private let cellIdentifier: String = "RatingTableViewCell"
    private let sortingButtonImage = UIImage(named: "sortButtonImage")
    private var presenter: RatingTablePresenterProtocol

    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let sortingButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        self.presenter = RatingTablePresenter()
        super.init(nibName: nil, bundle: nil)
        presenter.setView(view: self)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = RatingTablePresenter()
        super.init(coder: coder)
        presenter.setView(view: self)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showProgressHud() {
        ProgressHUD.show()
    }
    
    func hideProgressHud() {
        ProgressHUD.dismiss()
    }
    
    func showSortOptionsAlert() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        let nameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.presenter.sortItemsByKey(key: .name)
        }
        
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter.sortItemsByKey(key: .score)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let actions = [nameAction, ratingAction, cancelAction]
        actions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.ypWhite
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(RatingTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        sortingButton.setImage(sortingButtonImage, for: .normal)
        sortingButton.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc
    private func sortingButtonTapped() {
        presenter.sortingButtonTapped()
    }
    
    private func setupUI() {
        view.addSubview(sortingButton)
        view.addSubview(tableView)

        tableView.separatorStyle = .none

        NSLayoutConstraint.activate([
            sortingButton.heightAnchor.constraint(equalToConstant: 42),
            sortingButton.widthAnchor.constraint(equalToConstant: 42),
            sortingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            sortingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortingButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),

            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: sortingButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

extension RatingTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfo = presenter.item(at: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RatingTableViewCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setupCell(position: indexPath.row + 1, score: cellInfo.rating, name: cellInfo.name, imageString: cellInfo.avatar)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profilePresenter = presenter.presenterForProfileViewController(for: indexPath.row)
        let vc = UserProfileViewController(presenter: profilePresenter)
        navigationController?.pushViewController(vc, animated: true)
    }
}


