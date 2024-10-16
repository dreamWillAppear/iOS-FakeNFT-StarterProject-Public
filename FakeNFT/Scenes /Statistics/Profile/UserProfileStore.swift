//
//  UserProfileStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

protocol UserProfileStoreProtocol {
    func profile(for index: Int) -> Profile?
}

final class UserProfileStore: UserProfileStoreProtocol {
    private let profilesList: [Profile] = [
        Profile(
        name: "Sasha",
        image: "https://via.placeholder.com/200",
        description: "yung folawer 21",
        nftNumber: 202,
        profileURL: "google.com"
    )]
    
    func profile(for index: Int) -> Profile? {
        return profilesList[0] //TODO: переделаю когда будут запросы в сеть
    }
}

