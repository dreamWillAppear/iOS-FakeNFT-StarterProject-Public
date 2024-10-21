//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import UIKit

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var view: EditProfileViewProtocol?
    
    init(view: EditProfileViewProtocol) {
        self.view = view
    }
    
    func loadProfileData() {
        let profile = Profile(
            avatarImageURL: "avatar",
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "Joaquin Phoenix.com"
        )
        view?.updateProfile(profile)
    }
    
    func saveProfile(name: String, description: String, website: String) {
        print("Profile saved: \(name), \(description), \(website)")
    }
}
