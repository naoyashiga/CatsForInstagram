//
//  FavoriteDetailViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/21.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteDetailViewController: PhotoDetailViewController {
    var favorite = Favorite()
    var tmpFavorite = Tmp()
    
    struct Tmp {
        var id = ""
        var standardResolutionURLString = ""
        var lowResolutionBase64ImageString = ""
        var standardResolutionBase64ImageString = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 10.0
        favoriteButton.selected = true
        
        detailImageView.image = favorite.lowResolutionBase64ImageString.String2Image()
        
        //favoriteをコピー
        tmpFavorite.id = favorite.id
        tmpFavorite.standardResolutionURLString = favorite.standardResolutionURLString
        tmpFavorite.lowResolutionBase64ImageString = favorite.lowResolutionBase64ImageString
        tmpFavorite.standardResolutionBase64ImageString = favorite.standardResolutionBase64ImageString

        let realm = Realm()
        let predicate = NSPredicate(format: "id == %@", favorite.id)
        
        if realm.objects(Favorite).filter(predicate).count == 0 {
            //お気に入り未登録
            favoriteButton.selected = false
        } else {
            //お気に入り登録済み
            favoriteButton.selected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateFavorite() {
        let realm = Realm()
        
        let predicate = NSPredicate(format: "id == %@", tmpFavorite.id)
        let exisitingFavoriteArray = realm.objects(Favorite).filter(predicate)
        
        if favoriteButton.selected {
            //お気に入り削除
            if exisitingFavoriteArray.count != 0 {
                
                realm.write {
                    realm.delete(exisitingFavoriteArray[0])
                    
                    self.favoriteButton.selected = false
                }
            }
            
        } else {
            //お気に入り追加
            if exisitingFavoriteArray.count == 0 {
                
                let addingFavorite = Favorite()
                addingFavorite.id = tmpFavorite.id
                addingFavorite.lowResolutionBase64ImageString = tmpFavorite.lowResolutionBase64ImageString
                addingFavorite.standardResolutionBase64ImageString = tmpFavorite.standardResolutionBase64ImageString
                
                addingFavorite.createdAt = NSDate().timeIntervalSince1970
                
                realm.write {
                    realm.add(addingFavorite, update: true)
                    
                    self.favoriteButton.selected = true
                }
            }
        }
        
        favoriteButton.playBounceAnimation()
    }
    
    override func saveImageToCameraRoll() {
        var savingImageView = UIImageView()
        
        //高画質画像を読み込み、保存
        savingImageView.sd_setImageWithURL(
            NSURL(string: tmpFavorite.standardResolutionURLString),
            completed: { savingImage, error, type, URL in
                
                if error == nil {
                    UIImageWriteToSavedPhotosAlbum(savingImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
                    
                } else {
                    println("保存したい画像を取得できませんでした")
                    
                }
        })
    }
    
}
