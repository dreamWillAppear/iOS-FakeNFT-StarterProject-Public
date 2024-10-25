//
//  EditProfilePresenterProtocol.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

protocol EditProfilePresenterProtocol {
    func loadProfileData()
    func saveProfile(name: String, description: String, website: String, avatarURL: String)
}