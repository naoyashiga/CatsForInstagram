//
//  Favorite.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/16.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import RealmSwift

class Favorite: Object {
    dynamic var id = ""
    dynamic var lowResolutionImageURLString = ""
    dynamic var lowResolutionBase64ImageString = ""
    dynamic var standardResolutionBase64ImageString = ""
    
    dynamic var createdAt:Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}