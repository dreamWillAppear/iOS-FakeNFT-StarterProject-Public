//
//  UserProfileStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 15.10.2024.
//

protocol UserProfileStoreProtocol {
    func profile(for index: Int) -> Profile?
    func webSiteURLString(for index: Int) -> String?
}

final class UserProfileStore: UserProfileStoreProtocol {
    let statisticsService = StatisticNetworkServise()
    private var profilesList: [Profile] = []

    init() {
        fetchProfiles()
    }
    
    func fetchProfiles() {
        statisticsService.fetchUsers() { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.profilesList = profiles
            case .failure:
                break
            }
        }
    }
    func profile(for index: Int) -> Profile? {
        return profilesList[index]
    }
    
    func webSiteURLString(for index: Int) -> String? {
        if index > profilesList.count - 1 { return nil }
        return profilesList[index].website
    }
}

