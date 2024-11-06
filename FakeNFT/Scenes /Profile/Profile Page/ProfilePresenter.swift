//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    func loadProfileData()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func loadProfileData() {
        UIProfileBlockingProgressHUD.show()
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let name = json["name"] as? String,
                       let avatar = json["avatar"] as? String,
                       let description = json["description"] as? String,
                       let website = json["website"] as? String,
                       let nfts = json["nfts"] as? [String],
                       let likes = json["likes"] as? [String] {
                        
                        let profile = Profile(
                            avatarImageURL: avatar,
                            name: name,
                            description: description,
                            website: website,
                            nfts: nfts,
                            likes: likes
                        )
                        DispatchQueue.main.async {
                            self?.view?.updateProfile(profile)
                            UIProfileBlockingProgressHUD.dismiss()
                        }
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

