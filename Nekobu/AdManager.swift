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
    
    private static let ud = NSUserDefaults.standardUserDefaults()
    
    struct keyName {
        static let adCounter = "adCounter"
    }
    
    struct Cycle {
        static var top = 9
    }
    
    static func setAdCounter(){
        
        if ud.objectForKey(keyName.adCounter) == nil {
            ud.setObject(0, forKey: keyName.adCounter)
        } else {
            adCounter = ud.integerForKey(keyName.adCounter)
        }
        
    }
    
    static func countUp(){
        adCounter = adCounter + 1
        ud.setInteger(adCounter, forKey: keyName.adCounter)
    }
}