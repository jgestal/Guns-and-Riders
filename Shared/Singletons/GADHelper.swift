//
//  AdHelper.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 5/7/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import GoogleMobileAds

class GADHelper: NSObject {
    static let shared = GADHelper()
    
    let appID = "ca-app-pub-8604842873072804~8838867105"
    let intersticialID = "ca-app-pub-8604842873072804/1059491574"
    var randomFrecuency = 2
    
    var interstitial: GADInterstitial!
    
    func configure() {
        if !IAPHelper.shared.isAdsEnabled() { return }
        GADMobileAds.configure(withApplicationID: appID)
        interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {

        let interstitial = GADInterstitial(adUnitID: intersticialID)
        let request = GADRequest()
      //  request.testDevices = [kGADSimulatorID,"a6625937a88bcb524f606f0eee8e94781dec8a6e","1156efdcc7437a6d44c236e1560db53c8abef55f","8d3ca9b29947898e443b2d51ffb90e85"]
        interstitial.load(request)
        return interstitial
    }

    //TODO: Implement Random Frecuency
    func showAd() {
        if !IAPHelper.shared.isAdsEnabled() { return }
        let random = Int.random(0, randomFrecuency)
        print("*** GAD Helper: Show Ad Random: \(random)")
        if random == 0 {
            if interstitial.isReady {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let rootViewController = appDelegate.window?.rootViewController {
                    interstitial.present(fromRootViewController: rootViewController)
                    interstitial = createAndLoadInterstitial()
                }
            } else {
                print("*** GAD Helper: Ad was not ready")
            }
        }
    }
}
