//
//  RatingTablePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//
import UIKit

protocol RatingTablePresenterProtocol {
    func sortingButtonTapped()
    func numberOfItems() -> Int
    func item(at index: Int) -> Rating?
    func profile(for index: Int) -> Profile?
    func setView(view: RatingTableViewControllerProtocol)
}

protocol RatingTableViewControllerProtocol: AnyObject {
    func reloadData()
    func showSortOptionsAlert(actions: [UIAlertAction])
}


class RatingTablePresenter: RatingTablePresenterProtocol {
    weak var view: RatingTableViewControllerProtocol?
    private let store = RatingStore()

    func setView(view: any RatingTableViewControllerProtocol) {
        self.view = view
    }
    
    func sortingButtonTapped() {
        let nameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.sortItems(by: .name)
        }
        
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortItems(by: .score)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)

        view?.showSortOptionsAlert(actions: [nameAction, ratingAction, cancelAction])
    }

    private func sortItems(by key: SortingKeys) {
        store.changeSortingKey(sortingKey: key)
        view?.reloadData()
    }

    func numberOfItems() -> Int {
        return store.numberOfRatings()
    }

    func item(at index: Int) -> Rating? {
        return store.rating(for: index)
    }
    
    func profile(for index: Int) -> Profile? {
        return store.profile(for: index)
    }
}
