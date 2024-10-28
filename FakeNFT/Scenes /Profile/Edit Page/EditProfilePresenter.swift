//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var view: EditProfileViewProtocol?
    
    init(view: EditProfileViewProtocol) {
        self.view = view
    }
    
    func loadProfileData() {
        
    }
    
    func saveProfile(profile: Profile) {
        print("Profile saved: \(profile.name), \(profile.description), \(profile.website), \(profile.avatarImageURL)")
        
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let contentType = "application/x-www-form-urlencoded"
        let accept = "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let params = [
            "name": profile.name,
            "description": profile.description,
            "avatar": profile.avatarImageURL,
            "website": profile.website
        ]
        let bodyString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during network request: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("Profile updated successfully")
            } else {
                print("Server error: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
