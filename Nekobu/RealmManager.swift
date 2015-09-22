//
//  RealmManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/09/22.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    private static var _sharedInstance: Realm?
    
    static var sharedInstance: Realm? {
        
        if _sharedInstance == nil {
//            _sharedInstance = migrate()
        }
        
        return _sharedInstance
    }
    
    private init() {
        
    }
    
//    private class func migrate() -> Realm {
//        
//        let oldVersion: UInt64
//        
//        do {
//            oldVersion = try version()
//        }
//    }
}