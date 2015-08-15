//
//  Config.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static let tagName = "ねこ部"
    static let encodingtagName = tagName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    static let CLIENT_ID = "85f989a44f284ca5a7f7e66aeddd0a3c"
    static let CLIENT_SECRET = "e7cbbf8faa204e3385cc5014decb4a74"
    static let ENDPOINT = "https://api.instagram.com/v1/media/popular?client_id=" + CLIENT_ID
    static let TAG = "https://api.instagram.com/v1/tags/\(encodingtagName)/media/recent?client_id=" + CLIENT_ID
}