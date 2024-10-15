//
//  RatingStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.
//


import Foundation


protocol RatingStoreProtocol {
    func numberOfRatings() -> Int
    func rating(for index: Int) -> Rating?
}

enum SortingKeys: String {
    case score = "score"
    case name = "name"
}

final class RatingStore: RatingStoreProtocol {
    private var sortingKey: SortingKeys {
        get {
            let keyString = UserDefaults.standard.string(forKey: "sortingKey") ?? "score"
            return SortingKeys(rawValue: keyString) ?? .score
        } set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "sortingKey")
        }
    }

    var sortedRating: [Rating] {
        unsortedRatings.sorted { [weak self] in
            switch self?.sortingKey {
            case .score:
                return $0.score > $1.score
            case .name:
                return $0.name < $1.name
            default:
                return $0.score < $1.score
            }
        }
    }

    private let unsortedRatings: [Rating] = [
        Rating(imageURLString: "https://via.placeholder.com/200", name: "Sasha", score: 215),
        Rating(imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", name: "Oleg", score: 105),
        Rating(imageURLString: "https://www.example.com/image.jpg", name: "Zlata", score: 200),
        Rating(imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", name: "Artem", score: 110),
        Rating(imageURLString: "https://www.example.com/image.jpg", name: "Jenya", score: 88)
    ]

    private func changeKey(sortingKey: SortingKeys) {
        self.sortingKey = sortingKey
    }

    func numberOfRatings() -> Int {
        return sortedRating.count
    }

    func rating(for index: Int) -> Rating? {
        return sortedRating[index]
    }

    func changeSortingKey(sortingKey: SortingKeys) {
        changeKey(sortingKey: sortingKey)
    }
    
//    func profile(for index: Int) -> Profile? {
//        let profile = Profile(
//            name: "Sasha",
//            image: "https://via.placeholder.com/200",
//            description: "yung folawer 21",
//            nftNumber: 202,
//            profileURL: "google.com"
//        )
//        return profile
//    }
}
