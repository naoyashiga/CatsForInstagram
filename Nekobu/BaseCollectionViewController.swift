//
//  BaseCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

struct cellSize {
    static var width:CGFloat = 0.0
    static var height:CGFloat = 0.0
}

struct cellMargin {
    static let vertical:CGFloat = 0.0
    static let horizontal:CGFloat = 20.0
}

class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setCollectionView() {
        let edgeInsetBottom:CGFloat = 0
        let edgeInsetTop:CGFloat = 0
        
        cellSize.width = view.bounds.width / 2
        cellSize.height = view.bounds.width / 2
        
        if let collectionView = collectionView {
            collectionView.contentInset = UIEdgeInsetsMake(edgeInsetTop, 0, edgeInsetBottom, 0)
            collectionView.backgroundColor = UIColor.viewBackgroundColor()
        }
    }
    
    func setCornerRadius<T: UICollectionReusableView>(headerView headerView:T) -> T {
        let cornerRadius: CGFloat = 5.0
        let maskPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: ([UIRectCorner.TopLeft, UIRectCorner.TopRight]), cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = headerView.bounds
        maskLayer.path = maskPath.CGPath
        headerView.layer.mask = maskLayer
        
        return headerView
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellSize.width, height: cellSize.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin.vertical
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
