//
//  ReviewManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/22.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

final class ReviewManager: NSObject {
    static var reviewCounter = 0
    static var isReview = true
    
    private static let ud = NSUserDefaults.standardUserDefaults()
    
    struct Cycle {
        static var top = 8
    }
    
    struct keyName {
        static let reviewCounter = "reviewCounter"
        static let isReview = "isReview"
    }
    
    static func setting() {
        setReviewCounter()
        setIsReview()
    }
    
    static func update() {
        setIsReview()
    }
    
    private static func setReviewCounter(){
        if ud.objectForKey(keyName.reviewCounter) == nil {
            ud.setObject(0, forKey: keyName.reviewCounter)
        } else {
            reviewCounter = ud.integerForKey(keyName.reviewCounter)
        }
    }
    
    private static func setIsReview(){
        if ud.objectForKey(keyName.isReview) == nil {
            ud.setObject(true, forKey: keyName.isReview)
            isReview = true
        }else{
            isReview = ud.boolForKey(keyName.isReview)
        }
    }
    
    static func countUp(){
        reviewCounter = reviewCounter + 1
        ud.setInteger(reviewCounter, forKey: keyName.reviewCounter)
    }
    
    static func updateReviewStatus() {
        if ud.objectForKey(keyName.isReview) == nil {
            ud.setObject(false, forKey: keyName.isReview)
        } else {
            ud.setBool(false, forKey: keyName.isReview)
        }
    }
}