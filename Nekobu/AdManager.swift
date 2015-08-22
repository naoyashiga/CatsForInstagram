//
//  AdManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/22.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class AdManager: NSObject {
    static var adCounter = 0
    static let ADUNIT_ID = "ca-app-pub-9360978553412745/4402139911"
    
    private static let ud = NSUserDefaults.standardUserDefaults()
    
    struct Cycle {
        static var top = 9
    }
    
    static func setAdCounter(){
        
        if ud.objectForKey("adCounter") == nil {
            ud.setObject(0, forKey: "adCounter")
        } else {
            adCounter = ud.integerForKey("adCounter")
        }
        
    }
    
    static func countUp(){
        adCounter = adCounter + 1
//        println(adCounter)
        ud.setInteger(adCounter, forKey: "adCounter")
    }
}