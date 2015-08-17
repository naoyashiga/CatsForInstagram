//
//  String+String2Image.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/17.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func String2Image() -> UIImage? {
        
        //空白を+に変換する
        var base64String = stringByReplacingOccurrencesOfString(" ", withString:"+",options: nil, range:nil)
        
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:NSData? =
        NSData(base64EncodedString:base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess)
            
            //結果を返却
            return img
        }
        
        return nil
        
    }
}
