//
//  FavoriteCollectionViewController+DZNEmptyDataSet.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/16.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

extension FavoriteCollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: DZNEmptyDataSetSource
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "fav_off.png")
    }
    
    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.grayColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "お気に入りは0件です"
        let font = UIFont(name: "HiraKakuProN-W6", size: 30)!
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "feedのねこ写真をタップ後、星マークをタップ!"
        let font = UIFont(name: "HiraKakuProN-W3", size: 14)!
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    
    func buttonImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "reloadButton.png")
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        collectionView?.reloadData()
    }
}
