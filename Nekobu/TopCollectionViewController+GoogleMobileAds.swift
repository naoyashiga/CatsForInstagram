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
        interstitial = GADInterstitial(adUnitID: AdManager.ADUNIT_ID)
        interstitial!.delegate = self
        let request = GADRequest() // create request
//        request.testDevices = [kGADSimulatorID]
        request.testDevices = ["0b0df889514cace63baf0d3f248e5295"]
        interstitial!.loadRequest(request)
    }
    
    func settingAd(){
        let MY_BANNER_UNIT_ID = "ca-app-pub-9360978553412745/9261475110"
        
        let origin = CGPointMake(
            0.0,
            view.bounds.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - PageMenuConstraint.menuHeight)
        
        let size = GADAdSizeFullWidthPortraitWithHeight(50)
        let adB = GADBannerView(adSize: size, origin: origin)
        adB.adUnitID = MY_BANNER_UNIT_ID
        adB.delegate = self
        adB.rootViewController = self
        
        view.addSubview(adB)
        
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        request.testDevices = ["0b0df889514cace63baf0d3f248e5295"]
        adB.loadRequest(request)
    }

    func checkInterstitialAd(#photoDetailViewController: PhotoDetailViewController) {
        AdManager.setAdCounter()
        
        if AdManager.adCounter != 0 && AdManager.adCounter % AdManager.Cycle.top == 0{
            if(interstitial!.isReady){
                interstitial!.presentFromRootViewController(self)
            }
            
            //次の広告の準備
            settingInterstitialAd()
        } else {
            
            view.window?.rootViewController?.presentViewController(photoDetailViewController, animated: true, completion: nil)
        }
        
        AdManager.countUp()
    }
}