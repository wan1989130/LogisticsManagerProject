//
//  CommonSelectImageView.swift
//  MiddleSchool2
//
//  Created by 李琪 on 2017/10/17.
//  Copyright © 2017年 王岩. All rights reserved.
//

import UIKit
import Photos
import SKPhotoBrowser

typealias SelectPhotoBlock = (_ photoArray:Array<PhotoBrowserShowModel>, _ height:CGFloat)->Void

class CommonSelectImageView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource ,TZImagePickerControllerDelegate,SKPhotoBrowserDelegate{
    var canEdit = true
    var columnCount:Int = 3{//每行显示图片数量
        didSet{
            self.collectionHeightConstraint.constant = kwidth / CGFloat(columnCount)
            kheight = kwidth / CGFloat(columnCount)
            collectionView.reloadData()
        }
    }
    var kwidth = UIScreen.main.bounds.width{
        didSet{
            self.collectionHeightConstraint.constant = kwidth / CGFloat(columnCount)
            kheight = kwidth / CGFloat(columnCount)
            collectionView.reloadData()
        }
    }
    var kheight = UIScreen.main.bounds.width / 3
    
    var viewHeight:CGFloat{
        get{
            return collectionHeightConstraint.constant
        }
    }
    var model = PhotoBrowserShowModel()
    var photoArray:Array<PhotoBrowserShowModel> = [PhotoBrowserShowModel]()
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    var selectedAssets:NSMutableArray = NSMutableArray()
    var imagePicker:TZImagePickerController!
    var selectPhotoBlock:SelectPhotoBlock?
    var photos:Array<SKPhoto> = [SKPhoto]()
    var total = 5
    
    let layout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    fileprivate func commonInit(){
        resetLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        //注册一个cell
        collectionView.register(UINib.init(nibName: "CollectImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectImageCollectionViewCell")
        
        layoutIfNeeded()
    }
    
    fileprivate func resetLayout(){
        layout.itemSize = CGSize(width:kwidth / CGFloat(columnCount), height:kwidth / CGFloat(columnCount))
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    func update(photos:Array<PhotoBrowserShowModel>, selectPhotoBlock:@escaping SelectPhotoBlock){
        resetLayout()
        self.selectPhotoBlock = selectPhotoBlock
        self.photoArray = photos
        var showRowCount:Int = 0
        if canEdit{
            if self.photoArray.count == total{
                showRowCount = self.photoArray.count / columnCount
            }else{
                showRowCount = self.photoArray.count / columnCount + 1
            }
            
        }else{
            showRowCount = Int(ceil(Double(self.photoArray.count) / Double(columnCount)))
        }
        self.collectionHeightConstraint.constant = CGFloat(showRowCount) * self.kheight
        
        initImagePick(urlCount: 0)
        
        collectionView.reloadData()
    }
    
    func update(photos:Array<PhotoBrowserShowModel>){
        update(photos: photos) { (photos, height) in
            
        }
    }
    
    func initImagePick(urlCount:Int){
        imagePicker = TZImagePickerController.init(maxImagesCount: total, delegate: self,urlCount:urlCount)
        // 在内部是否显示拍照按钮
        imagePicker?.allowTakePicture = true
        // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
        imagePicker?.sortAscendingByModificationDate = false
    }
    
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if canEdit{
            return photoArray.count == total ? photoArray.count : (photoArray.count + 1)
        }else{
            return photoArray.count
        }
    }
    
    //自定义cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectImageCollectionViewCell", for: indexPath) as! CollectImageCollectionViewCell
        if canEdit && indexPath.row == photoArray.count && photoArray.count != total{
//            cell.testImage.image = UIImage.init(named: "AlbumAddBtn")
            cell.defaultImage.image  = UIImage.init(named: "AlbumAddBtn")
            cell.testImage.image = UIImage.init()
            cell.deleteBtn.isHidden = true
            cell.defaultImage.isHidden = false
            cell.defaultView.isHidden = false
        }else{
            cell.defaultImage.isHidden = true
            cell.defaultView.isHidden = true
            let model = photoArray[indexPath.row]
            
            if model.photoType == .image{
                cell.testImage.image = photoArray[indexPath.row].image
            }else{
                if model.thumbnailUrl == "" {
                    cell.testImage.setImage(url: model.imageUrl, placeholder: defaultImage)
                }
                else{
                    cell.testImage.setImage(url: model.thumbnailUrl, placeholder: defaultImage)
                }
            }
            
            cell.deleteBtn.isHidden = !canEdit
        }
        
        cell.deleteBlock = { () in
            self.photoArray.remove(at: indexPath.row)
            var showRowCount = 0
            if self.photoArray.count > 0 {
                if self.photoArray.count == self.total{
                    showRowCount = self.photoArray.count / self.columnCount
                    self.collectionHeightConstraint.constant = CGFloat(showRowCount) * self.kheight
                }else{
                    showRowCount = self.photoArray.count / self.columnCount + 1
                    self.collectionHeightConstraint.constant = CGFloat(showRowCount) * self.kheight
                }
            }else{
                self.collectionHeightConstraint.constant = self.kheight
            }
            self.selectPhotoBlock?(self.photoArray, self.collectionHeightConstraint.constant)
            self.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == photoArray.count{
            var index = 0
            let temMut:NSMutableArray = NSMutableArray()
            for i in 0..<photoArray.count{
                if photoArray[i].photoType == .image && photoArray[i].asset != nil{
                    temMut.add(photoArray[i].asset!)
                    
                }else{
                    index = index + 1
                }
            }
            initImagePick(urlCount:index)
            imagePicker?.selectedAssets = temMut
            imagePicker.maxImagesCount = total
            imagePicker.urlCount = index
            
            imagePicker?.didFinishPickingPhotosHandle = {
                (photos,assets,isSelectOriginalPhoto) in
                if photos != nil && (photos?.count)! > 0{
                    var temPhotoArray = [PhotoBrowserShowModel]()
                    for i in 0..<self.photoArray.count{
                        if self.photoArray[i].photoType == .url{
                            temPhotoArray.append(self.photoArray[i])
                        }
                    }
                    self.photoArray = temPhotoArray
                    var showRowCount = 0
                    if photos!.count > 0 {
                        for i in 0..<photos!.count{
                            let model = PhotoBrowserShowModel()
                            model.image = photos![i]
                            model.asset = assets![i] as? PHAsset
                            model.photoType = .image
                            self.photoArray.append(model)
                        }
                        if self.photoArray.count == self.total {
                            showRowCount = self.photoArray.count / self.columnCount
                        }else{
                            showRowCount = self.photoArray.count / self.columnCount + 1
                        }
                        
                        self.collectionHeightConstraint.constant = CGFloat(showRowCount) * self.kheight
                    }else{
                        self.collectionHeightConstraint.constant = self.kheight
                    }
                    self.selectPhotoBlock?(self.photoArray, self.collectionHeightConstraint.constant)
                    self.collectionView.reloadData()
                    
                }else{
                    print("没有选择任何图片")
                }
            }
            
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
        }else{
            photos.removeAll()
            for index in 0..<photoArray.count {
                
                var photo:SKPhoto!
                if photoArray[index].photoType == .image{
                    photo = SKPhoto.photoWithImage(photoArray[index].image!)
                }else{
//                    photo = SKPhoto.photoWithImageURL(photoArray[index].imageUrl, holder: defaultFullScreenImage)
                    photo = SKPhoto.photoWithImageURL(photoArray[index].imageUrl)
                }
                photo.shouldCachePhotoURLImage = true
                photos.append(photo)
            }
            
            let browser = SKPhotoBrowser(photos: photos)
            browser.delegate = self
            
            browser.initializePageIndex(indexPath.row)
            browser.delegate = self as SKPhotoBrowserDelegate
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.displayBackAndForwardButton = false
            UIApplication.shared.keyWindow?.rootViewController?.present(browser, animated: true, completion: nil)
        }
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        
    }
    

}
