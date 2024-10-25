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
        
    }
    
    func saveProfile(name: String, description: String, website: String, avatarURL: String) {
        print("Profile saved: \(name), \(description), \(website), \(avatarURL)")
        
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let params = [
            "name": name,
            "description": description,
            "avatar": avatarURL,
            "website": website
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

struct ProfileUpdateRequest: Codable {
    let name: String
    let description: String
    let avatar: String
    let website: String
}
