//
//  Media.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

struct Media {
    var type = ""
    var id = ""
    var lowResolutionImageURL: NSURL?
    var standardResolutionImageURL: NSURL?
    var lowResolutionBase64ImageString = ""
    var standardResolutionBase64ImageString = ""
    var video: Video?
}
