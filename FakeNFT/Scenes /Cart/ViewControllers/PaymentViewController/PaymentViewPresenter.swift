//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 23.10.2024.
//

import Foundation

protocol PaymentViewPresenterProtocol {
    func getPaymentData() -> [Payment]
    func getResultOfPayment() -> Bool
}

final class PaymentViewPresenter: PaymentViewPresenterProtocol {
    
    private let data = MokeEnum.payment
    
    func getPaymentData() -> [Payment] {
        return data
    }
    
    func getResultOfPayment() -> Bool {
        return [true, false].randomElement() ?? false
    }
}
