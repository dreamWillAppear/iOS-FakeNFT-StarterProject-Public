//
//  DeleteViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 01.11.2024.
//

import Foundation

protocol DeleteViewPresenterProtocol: AnyObject {
    var view: DeleteViewControllerProtocol?{ get set }
    func fetchDeleteNft(order: CartResult, deletetedNft: String)
}

final class DeleteViewPresenter: DeleteViewPresenterProtocol {
    
    var view: DeleteViewControllerProtocol?
    
    private let deleteService = DeleteService.shared
    
    init(view: DeleteViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func fetchDeleteNft(order: CartResult, deletetedNft: String) {
        deleteService.fetchPayment(order: order, deletetedNft: deletetedNft) { result in
            switch result {
            case .success(_):
                print("delete is successful")
                self.view?.didDelete()
                self.view?.dismissVC()
            case .failure(_):
                print("error with delete nft from order")
                self.view?.dismissVC()
            }
        }
    }
}
