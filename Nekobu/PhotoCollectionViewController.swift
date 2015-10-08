//
//  PhotoCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/21.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: BaseCollectionViewController {
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()

        if let collectionView = collectionView {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//            collectionView.addSubview(refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
}
