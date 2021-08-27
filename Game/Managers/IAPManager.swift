//
//  IAPManager.swift
//  Find Pair
//
//  Created by Yaroslav Babiy on 26.08.2021.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    static let shared = IAPManager()
    private override init() {}
    
    var products: [SKProduct] = []
    
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
    }
    
    public func getProducts() {
        let identifiers: Set = [
            IAPProducts.removeAdsNonConsumable.rawValue,
            IAPProducts.carsCategoryNonConsumable.rawValue,
            IAPProducts.sportCategoryNonConsumable.rawValue,
            IAPProducts.foodCategoryNonConsumable.rawValue
        ]
        
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach{ print($0.localizedTitle) }
    }
}
