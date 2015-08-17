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
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edgeInsetBottom:CGFloat = 0
        let edgeInsetTop:CGFloat = 0
        
        cellSize.width = view.bounds.width / 2
        cellSize.height = view.bounds.width / 2
        
        if let collectionView = collectionView {
            collectionView.contentInset = UIEdgeInsetsMake(edgeInsetTop, 0, edgeInsetBottom, 0)
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            collectionView.addSubview(refreshControl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
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
