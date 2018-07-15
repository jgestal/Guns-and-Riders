//
//  IAPHelper.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 5/7/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

class IAPHelper: NSObject {
    
    static let removeAdsProductID = "guns.and.riders_remove.ads"
    static let shared = IAPHelper(productIdentifiers: [IAPHelper.removeAdsProductID])
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"

    var products : [SKProduct]!
    
    init(productIdentifiers: Set<String>) {
        
      //  UserDefaults.standard.set(false, forKey: IAPHelper.removeAdsProductID)
      //  UserDefaults.standard.synchronize()
        
        self.productIdentifiers = productIdentifiers
        for identifier in productIdentifiers {
            if UserDefaults.standard.bool(forKey: identifier) {
                self.purchasedProductIdentifiers.insert(identifier)
                print("*** IAP HELPER: Previously purchased: \(identifier)")
            } else {
                print("*** IAP HELPER: Not purchased: \(identifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    private let productIdentifiers: Set<String>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var purchasedProductIdentifiers = Set<ProductIdentifier>()
}

extension IAPHelper {
    
    func isAdsEnabled() -> Bool {
        return !(UserDefaults.standard.bool(forKey: "fourAcesTrick") || isProductPurchased(IAPHelper.removeAdsProductID))
    }
    
    func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("*** IAP HELPER: Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func buyProductWithID(_ identifier: String) {
        self.requestProducts { (completed, products) in
            if completed {
                if let products = products {
                    products.forEach { if $0.productIdentifier == identifier { self.buyProduct($0) } }
                }
            } else {
                print("*** IAP Helper: Error buying product")
   
                let alert = UIAlertController.init(title: "Error", message: "Please, try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let rootViewController = appDelegate.window!.rootViewController
                rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        print("Loaded list of products...")
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            print("*** IAP Helper: \(error)")
            let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let rootViewController = appDelegate.window!.rootViewController
            rootViewController?.present(alert, animated: true, completion: nil)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}


extension IAPHelper {
    func isRemoveAdsPurchased() -> Bool {
        return isProductPurchased(IAPHelper.removeAdsProductID)
    }
}



