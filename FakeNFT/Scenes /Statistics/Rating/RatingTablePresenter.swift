//
//  RatingTablePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

protocol RatingTablePresenterProtocol: AnyObject {
    func sortingButtonTapped()
    func numberOfItems() -> Int
    func item(at index: Int) -> Profile?
    func setView(view: RatingTableViewControllerProtocol)
    func presenterForProfileViewController(for index: Int) -> UserProfilePresenter
    func sortItemsByKey(key: SortingKeys)
}

class RatingTablePresenter: RatingTablePresenterProtocol {
    weak var view: RatingTableViewControllerProtocol?
    private let store = RatingStore()
    
    func setView(view: any RatingTableViewControllerProtocol) {
        self.view = view
        
        store.presenter = self
        store.fetchRatings( completionOnSuccess: { [weak self] in
            self?.view?.hideProgressHud()
            self?.view?.reloadData()
        } , completionOnFailure: { [weak self] in
            self?.view?.hideProgressHud()
        })
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

    func item(at index: Int) -> Profile? {
        let profile = store.rating(for: index)
        return profile
    }
    
    func presenterForProfileViewController(for index: Int) -> UserProfilePresenter {
        let profile = item(at: index)
        let userProfilePresenter = UserProfilePresenter(profile: profile)
        return userProfilePresenter
    }
    
    func reloadData() {
        view?.reloadData()
    }
}

extension RatingTablePresenter: RatingStoreDelegateProtocol {
    func showProgressHud() {
        view?.showProgressHud()
    }
    
    func hideProgressHud() {
        view?.hideProgressHud()
    }
}
