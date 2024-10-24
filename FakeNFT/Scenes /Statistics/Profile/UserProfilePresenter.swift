//
//  UserProfilePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

import Foundation

protocol UserProfilePresenterProtocol {
    func profile() -> Profile?
    func presenterForCollection() -> NFTCollectionPresenter
    func webSiteURL() -> String?
}

final class UserProfilePresenter: UserProfilePresenterProtocol {
    let userProfileIndex: Int
    let store: UserProfileStoreProtocol
    init(userProfileIndex: Int) {
        self.userProfileIndex = userProfileIndex
        self.store = UserProfileStore()
    }
    
    func profile() -> Profile? {
        return store.profile(for: userProfileIndex)
    }
    
    func presenterForCollection() -> NFTCollectionPresenter {
        let presenter = NFTCollectionPresenter()
        return presenter
    }
    
    func webSiteURL() -> String? {
        return store.webSiteURLString(for: userProfileIndex)
    }
}

