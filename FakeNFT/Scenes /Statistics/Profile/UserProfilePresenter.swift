//
//  UserProfilePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

import Foundation

protocol UserProfilePresenterProtocol {
    func profile() -> Profile?
    func presenterForCollection() -> NFTCollectionPresenter?
    func webSiteURL() -> String?
}

final class UserProfilePresenter: UserProfilePresenterProtocol {
    let profileData: Profile?
    init(profile: Profile?) {
        self.profileData = profile
    }
    
    func profile() -> Profile? {
        return profileData
    }
    
    func presenterForCollection() -> NFTCollectionPresenter? {
        guard let profileData else { return nil }
        let presenter = NFTCollectionPresenter(nfts: profileData.nfts)
        return presenter
    }
    
    func webSiteURL() -> String? {
        return profileData?.website
    }
}

