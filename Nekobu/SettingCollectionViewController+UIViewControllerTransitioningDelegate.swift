//
//  SettingCollectionViewController+UIViewControllerTransitioningDelegate.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension SettingCollectionViewController: UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: self)
    }
}