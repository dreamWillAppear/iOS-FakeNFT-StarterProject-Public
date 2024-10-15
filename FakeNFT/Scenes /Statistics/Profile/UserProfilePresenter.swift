//
//  UserProfilePresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

protocol UserProfilePresenterProtocol {
    func profile() -> Profile?
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
}

