//
//  UIImage+Image2String.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/17.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func Image2String() -> String {
        
        let jpegData = UIImageJPEGRepresentation(self, 0.5)
        
        let encodeString =
        jpegData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        return encodeString
    }
}
