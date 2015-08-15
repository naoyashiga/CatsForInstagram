//
//  PageMenuViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class PageMenuViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    var controllerArray : [BaseCollectionViewController] = []
    
    private struct NibNameSet {
        static let topVC = "TopCollectionViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topVC = TopCollectionViewController(nibName: NibNameSet.topVC, bundle: nil)
        
        topVC.title = "cat"
        
        controllerArray.append(topVC)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.scrollMenuBackgroundColor()),
            .ViewBackgroundColor(UIColor.viewBackgroundColor()),
            .SelectionIndicatorColor(UIColor.selectionIndicatorColor()),
            //            .BottomMenuHairlineColor(UIColor.bottomMenuHairlineColor()),
            .SelectedMenuItemLabelColor(UIColor.selectedMenuItemLabelColor()),
            .UnselectedMenuItemLabelColor(UIColor.unselectedMenuItemLabelColor()),
            .SelectionIndicatorHeight(2.0),
            .MenuItemFont(UIFont(name: "HiraKakuProN-W6", size: 12.0)!),
            .MenuHeight(30.0),
            .MenuItemWidth(80.0),
            .MenuMargin(0.0),
            //            "useMenuLikeSegmentedControl": true,
            .MenuItemSeparatorRoundEdges(true),
            //            "enableHorizontalBounce": true,
            //            "scrollAnimationDurationOnMenuItemTap": 300,
            .CenterMenuItems(true)]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, view.frame.width, view.frame.height), pageMenuOptions: parameters)
        
        if let pageMenu = pageMenu {
            view.addSubview(pageMenu.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
