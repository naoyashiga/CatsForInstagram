//
//  Color.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func hexStr (var hexStr : NSString, var alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
    
    class func viewBackgroundColor() -> UIColor {
        return UIColor.hexStr("e5e5e5", alpha: 1)
    }
    
    class func navigationBarTintColor() -> UIColor {
        return UIColor.hexStr("ffa633", alpha: 1)
    }
    
    //MARK: Tab Color
    class func scrollMenuBackgroundColor() -> UIColor {
        return UIColor.hexStr("AAD9D1", alpha: 1)
    }
    
    class func selectionIndicatorColor() -> UIColor {
        return UIColor.hexStr("72505E", alpha: 1)
    }
    
    class func bottomMenuHairlineColor() -> UIColor {
        return UIColor.hexStr("efefef", alpha: 1)
    }
    
    class func selectedMenuItemLabelColor() -> UIColor {
        return UIColor.hexStr("72505E", alpha: 1)
    }
    
    class func unselectedMenuItemLabelColor() -> UIColor {
        return UIColor.hexStr("efefef", alpha: 1)
    }
}