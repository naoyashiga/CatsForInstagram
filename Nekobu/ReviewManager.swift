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
    
    static func setting() {
        setReviewCounter()
        setIsReview()
    }
    
    static func update() {
        setIsReview()
    }
    
    private static func setReviewCounter(){
        if ud.objectForKey("reviewCounter") == nil {
            ud.setObject(0, forKey: "reviewCounter")
        } else {
            reviewCounter = ud.integerForKey("reviewCounter")
        }
    }
    
    private static func setIsReview(){
        if ud.objectForKey("isReview") == nil {
            ud.setObject(true, forKey: "isReview")
            isReview = true
        }else{
            isReview = ud.boolForKey("isReview")
        }
    }
    
    static func countUp(){
        reviewCounter = reviewCounter + 1
        println(reviewCounter)
        ud.setInteger(reviewCounter, forKey: "reviewCounter")
    }
    
    static func updateReviewStatus() {
        if ud.objectForKey("isReview") == nil {
            ud.setObject(false, forKey: "isReview")
        } else {
            ud.setBool(false, forKey: "isReview")
        }
    }
}