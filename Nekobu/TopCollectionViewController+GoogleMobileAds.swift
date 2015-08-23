//
//  TopCollectionViewController+GoogleMobileAds.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension TopCollectionViewController: GADBannerViewDelegate, GADInterstitialDelegate {

    func settingInterstitialAd() {
        interstitial = GADInterstitial(adUnitID: AdConstraints.interstitialAdUnitID)
        interstitial!.delegate = self
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        request.testDevices = [AdConstraints.realDeviceID]
        interstitial!.loadRequest(request)
    }
    
    func settingAd(){
        
        let origin = CGPointMake(
            0.0,
            view.bounds.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - PageMenuConstraint.menuHeight)
        
        let size = GADAdSizeFullWidthPortraitWithHeight(50)
        let adB = GADBannerView(adSize: size, origin: origin)
        adB.adUnitID = AdConstraints.bannerAdUnitID
        adB.delegate = self
        adB.rootViewController = self
        
        view.addSubview(adB)
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        request.testDevices = [AdConstraints.realDeviceID]
        adB.loadRequest(request)
    }

    func checkInterstitialAd(#photoDetailViewController: PhotoDetailViewController) {
        AdManager.mySetCounter(AdManager.keyName.adCounter)
        
        if AdManager.counter != 0 && AdManager.counter % AdManager.Cycle.top == 0{
            if(interstitial!.isReady){
                interstitial!.presentFromRootViewController(self)
            }
            
            //次の広告の準備
            settingInterstitialAd()
        } else {
            
            view.window?.rootViewController?.presentViewController(photoDetailViewController, animated: true, completion: nil)
        }
        
        AdManager.countUp(AdManager.keyName.adCounter)
    }
}