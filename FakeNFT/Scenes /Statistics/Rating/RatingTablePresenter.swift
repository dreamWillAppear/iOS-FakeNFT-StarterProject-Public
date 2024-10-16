//
//  RatingTablePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

protocol RatingTablePresenterProtocol {
    func sortingButtonTapped()
    func numberOfItems() -> Int
    func item(at index: Int) -> Rating?
    func setView(view: RatingTableViewControllerProtocol)
    func presenterForProfileViewController(for index: Int) -> UserProfilePresenter
    func sortItemsByKey(key: SortingKeys)
}

class RatingTablePresenter: RatingTablePresenterProtocol {
    weak var view: RatingTableViewControllerProtocol?
    private let store = RatingStore()
    func setView(view: any RatingTableViewControllerProtocol) {
        self.view = view
    }
    
    func sortingButtonTapped() {
        view?.showSortOptionsAlert()
    }

    func sortItemsByKey(key: SortingKeys) {
        sortItems(by: key)
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
    
    func presenterForProfileViewController(for index: Int) -> UserProfilePresenter {
        let userProfilePresenter = UserProfilePresenter(userProfileIndex: index)
        return userProfilePresenter
    }
}
