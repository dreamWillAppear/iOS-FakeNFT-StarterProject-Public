//
//  RatingStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.
//


import Foundation

protocol RatingStoreProtocol {
    func numberOfRatings() -> Int
    func rating(for index: Int) -> Profile?
}

protocol RatingStoreDelegateProtocol: AnyObject {
    func reloadData()
    func showProgressHud()
    func hideProgressHud()
}

enum SortingKeys: String {
    case score = "rating"
    case name = "name"
}

final class RatingStore: RatingStoreProtocol {
    let statisticsService: StatisticNetworkServise
    weak var presenter: RatingStoreDelegateProtocol?
    
    init() {
        self.statisticsService = StatisticNetworkServise()
    }
    
    private var sortingKey: SortingKeys {
        get {
            let keyString = UserDefaults.standard.string(forKey: "sortingKey") ?? "rating"
            return SortingKeys(rawValue: keyString) ?? .score
        } set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "sortingKey")
        }
    }

    var sortedRating: [Profile] {
        unsortedRatings.sorted { [weak self] in
            switch self?.sortingKey {
            case .score:
                return $0.nfts.count > $1.nfts.count
            case .name:
                return $0.name < $1.name
            default:
                return $0.nfts.count > $1.nfts.count
            }
        }
    }

    private var unsortedRatings: [Profile] = []

    func fetchRatings(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        presenter?.showProgressHud()
        statisticsService.fetchUsers() { [weak self] result in
            switch result {
            case .success(let ratings):
                self?.unsortedRatings = ratings
                completionOnSuccess()
            case .failure:
                completionOnFailure()
                break
            }
        }
    }
    
    private func changeKey(sortingKey: SortingKeys) {
        self.sortingKey = sortingKey
    }

    func numberOfRatings() -> Int {
        return sortedRating.count
    }

    func rating(for index: Int) -> Profile? {
        if index > sortedRating.count - 1 { return nil }
        return sortedRating[index]
    }

    func changeSortingKey(sortingKey: SortingKeys) {
        changeKey(sortingKey: sortingKey)
    }
    
}
