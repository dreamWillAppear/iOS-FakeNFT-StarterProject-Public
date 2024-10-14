//
//  RatingTableViewController.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.
//

import UIKit

final class RatingTableViewController: UIViewController {
    private let cellIdentifier: String = "RatingTableViewCell"
    private let sortingButtonImage = UIImage(named: "sortButtonImage")
    private let store = RatingStore()

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

    @objc
    private func sortingButtonTapped() {

        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let nameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.changeSorting(sortingKey: .name)
        }

        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _  in
            self?.changeSorting(sortingKey: .score)
        }

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil) 

        alert.addAction(nameAction)
        alert.addAction(ratingAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
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

    private func changeSorting(sortingKey: SortingKeys) {
        store.changeSortingKey(sortingKey: sortingKey)
        tableView.reloadData()
    }
}

extension RatingTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.numberOfRatings()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfo = store.rating(for: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RatingTableViewCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setupCell(position: indexPath.row + 1, score: cellInfo.score, name: cellInfo.name, imageString: cellInfo.imageURLString)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let user = store.rating(for: indexPath.row) else { return }
        let profile = Profile(name: "Sasha", image: "https://via.placeholder.com/200", description: "yung folawer 21", nftNumber: 202, profileURL: "google.com")
        let vc = UserProfileViewController(profile: profile)
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


