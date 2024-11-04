//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 23.10.2024.
//

import Foundation
import ProgressHUD

protocol PaymentViewPresenterProtocol {
    var view: PaymentViewControllerProtocol? { get set }
    var paymentData: [PaymentResult]? { get set }
    func getResultOfPayment() -> Bool
    func fetchPayment()
    func fetchPay(paymentId: String)
}

final class PaymentViewPresenter: PaymentViewPresenterProtocol {
    
    private let paymentService = PaymentService.shared
    private let payService = PayService.shared
    
    var view: PaymentViewControllerProtocol?
    var paymentData: [PaymentResult]?
    var paySuccess: PayResult?
    
    init(view: PaymentViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func getResultOfPayment() -> Bool {
        let isSuccess = [true, false].randomElement() ?? false
        return isSuccess
    }
    
    func fetchPayment() {
        UICartBlockingProgressHUD.show()
        paymentService.fetchPayment() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let decodedData):
                print(decodedData)
                self.paymentData = decodedData
                UICartBlockingProgressHUD.dismiss()
            case .failure(_):
                print("fail cart")
            }
        }
    }
    
    func fetchPay(paymentId: String) {
        UICartBlockingProgressHUD.show()
        payService.fetchPay(paymentId: paymentId) { [weak self] result in
            guard let self = self else { return }
            UICartBlockingProgressHUD.dismiss()
            switch result {
            case .success(let value):
                self.paySuccess = value
                view?.presentResultOfPay(isSuccess: value.success)
            case .failure(_):
                self.paySuccess = nil
            }
        }
    }
}
