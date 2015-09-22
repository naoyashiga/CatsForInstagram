//
//  AdManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/22.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class AdManager: BaseUserDefaultManager {
    
    struct keyName {
        static let adCounter = "adCounter"
    }
    
    struct Cycle {
        static var top = 3
    }
}