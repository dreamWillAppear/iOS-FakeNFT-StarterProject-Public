//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 23.10.2024.
//

import Foundation
import ProgressHUD

protocol PaymentViewPresenterProtocol {
    func getPaymentData() -> [Payment]
    func getResultOfPayment() -> Bool
    func fetchPayment()
    var paymentData: [PaymentResult]? { get set }
}

final class PaymentViewPresenter: PaymentViewPresenterProtocol {
    
    private let data = MokeEnum.payment
    private let paymentService = PaymentService.shared
    
    var paymentData: [PaymentResult]?
    
    func getPaymentData() -> [Payment] {
        return data
    }
    
    func getResultOfPayment() -> Bool {
        let isSuccess = [true, false].randomElement() ?? false
        return isSuccess
    }
    
    func fetchPayment() {
        ProgressHUD.animate()
        paymentService.fetchPayment() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let decodedData):
                print(decodedData)
                self.paymentData = decodedData
                ProgressHUD.dismiss()
            case .failure(_):
                print("fail cart")
            }
        }
    }
}
