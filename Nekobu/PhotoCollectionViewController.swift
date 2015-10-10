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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
