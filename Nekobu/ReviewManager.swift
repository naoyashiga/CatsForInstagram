//
//  ReviewManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/22.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

final class ReviewManager: NSObject {
    static let REVIEW_CYCLE = 3
    static var reviewCounter = 0
    static var isReview = true
    
    static func setting() {
        setReviewCounter()
        setIsReview()
    }
    
    private static func setReviewCounter(){
        //ユーザデフォルト
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("reviewCounter") == nil){
            //カウンター
            ud.setObject(0, forKey: "reviewCounter")
        }else{
            reviewCounter = ud.integerForKey("reviewCounter")
        }
    }
    
    private static func setIsReview(){
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("isReview") == nil){
            //レビューを許可
            ud.setObject(true, forKey: "isReview")
            isReview = true
        }else{
            isReview = ud.boolForKey("isReview")
        }
    }
    
    static func countUp(){
        //カウンター増加
        let ud = NSUserDefaults.standardUserDefaults()
        reviewCounter = reviewCounter + 1
        println(reviewCounter)
        ud.setInteger(reviewCounter, forKey: "reviewCounter")
    }
}