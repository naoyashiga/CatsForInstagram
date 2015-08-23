//
//  PresentationManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

@objc public protocol RPZoomTransitionAnimating {
    func calculatedPositionSourceImageView() -> UIImageView
    func sourceImageView() -> UIImageView
    func transitionDestinationImageViewFrame() -> CGRect
}