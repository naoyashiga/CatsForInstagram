//
//  ReviewManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/22.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

final class ReviewManager: BaseUserDefaultManager {
    static var isReview = true
    
    struct Cycle {
        static var top = 8
    }
    
    struct keyName {
        static let reviewCounter = "reviewCounter"
        static let isReview = "isReview"
    }
    
    static func initialSetting() {
        mySetCounter(keyName.reviewCounter)
        setIsReview()
    }
    
    private static func setIsReview(){
        if ud.objectForKey(keyName.isReview) == nil {
            ud.setObject(true, forKey: keyName.isReview)
            isReview = true
        } else {
            isReview = ud.boolForKey(keyName.isReview)
        }
    }
    
    static func updateReviewStatus() {
        if ud.objectForKey(keyName.isReview) == nil {
            ud.setObject(false, forKey: keyName.isReview)
        } else {
            ud.setBool(false, forKey: keyName.isReview)
        }
    }
}