//
//  RatingStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 12.10.2024.
//

struct Rating {
    let position: Int
    let imageURLString: String
    let name: String
    let score: Int
}

protocol RatingStoreProtocol {
    func numberOfRatings() -> Int
    func rating(for index: Int) -> Rating?
}

enum SortingKeys {
    case score
    case name
}

final class RatingStore: RatingStoreProtocol {
    private var sortingKey = SortingKeys.score
    
    var sortedRating: [Rating] {
        unsortedRatings.sorted { [weak self] in
            switch self?.sortingKey {
            case .score:
                return $0.score > $1.score
            case .name:
                return $0.name < $1.name
            default:
                return $0.position < $1.position
            }
        }
    }
    
    private let unsortedRatings: [Rating] = [
        Rating(position: 1,imageURLString: "https://via.placeholder.com/200", name: "Sasha", score: 215),
        Rating(position: 34,imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", name: "Oleg", score: 105),
        Rating(position: 4,imageURLString: "https://www.example.com/image.jpg", name: "Zlata", score: 200),
        Rating(position: 2, imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", name: "Artem", score: 110),
        Rating(position: 5,imageURLString: "https://www.example.com/image.jpg", name: "Jenya", score: 88)
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
}
