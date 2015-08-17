//
//  ImageView+SDWebImage.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadingImageBySDWebImage(url: NSURL, callback: (UIImage) -> ()) {
        
        sd_setImageWithURL(
            url,
//            media.lowResolutionImageURL,
//            media.standardImageURL,
            completed: { image, error, type, URL in
                
                self.alpha = 0
                
                callback(image)
                
                UIView.animateWithDuration(0.25,
                    animations: {
                        self.alpha = 1
                })
        })
    }
}