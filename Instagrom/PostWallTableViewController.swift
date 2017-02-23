//
//  PostWallTableViewController.swift
//  Instagrom
//
//  Created by KaKa on 2017/2/20.
//  Copyright © 2017年 KaKa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import SDWebImage
import SVProgressHUD

class PostWallTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Data
    //1-1.建立資料庫的reference (像資料庫的table,或是說資料夾)
    var ref: FIRDatabaseReference! //會開在最上層
    var postsRef: FIRDatabaseReference!
    var postsQuery: FIRDatabaseQuery! //資料用query做排序
    
    /* Firebase提供的FirebaseDatabaseUI:Firebase針對不同平台發布的簡易UI元件
    將UITableView的datasource換成這個FUITableViewDataSource*/
    var dataSource: FUITableViewDataSource!

    //UI:imagePicker
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //動態調整row height高度,依據cell內的東西大小去長
        tableView.rowHeight = UITableViewAutomaticDimension
        //估測tableView總高度
        tableView.estimatedRowHeight = 369
        
        ref = FIRDatabase.database().reference()
        postsRef = ref.child("posts")//在ref下開一層新資料夾"posts"
        postsQuery = postsRef.queryOrdered(byChild: "postDateReversed") //資料用query做排序
        
        //FUITableViewDataSource
        dataSource = tableView.bind(to: postsQuery, populateCell: { (tableView, indexPath, snapshot) in
            //cell要轉成PostWallTableViewCell之後才可取得emailLabel,photoImageView
            let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostWallTableViewCell
            //snapshot就是Firebase裡database中的詳細照片資料，屬於 NSDictionary
            let post = snapshot.value as! [String:Any]
            //email顯示:從dictionary裡取資料
            postCell.emailLabel.text = post["email"] as! String?
            //photoImageView顯示
            let imageURL = URL(string: post["imageURL"] as! String)
            postCell.photoImageView.sd_setImage(with: imageURL)
            
            print("\(post)")
            return postCell
        })
        
        //imagePicker delegate
        imagePicker.delegate = self
        
//        //讀取資料
//        //observeSingleEvent 只讀一次
//        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            print("\(snapshot.value)")
//        })
        

    }
    
    //相機按鈕
    @IBAction func cameraTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //拍照
        /*isSourceTypeAvailable:確認使用者手機是否有這項功能
         isSourceTypeAvailable是class method,直接用UIImagePickerController,不需再建立物件*/
        if UIImagePickerController.isSourceTypeAvailable(.camera){ //一開始就先確認是否有camera的功能可以用,沒有就不顯示按鍵
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {(action) in
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            })
            alertController.addAction(cameraAction)
        }
        
        //相簿選取照片
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){ //一開始就先確認是否有photoLibrary的功能可以用,沒有就不顯示按鍵
            let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .default, handler: {(action) in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            })
            alertController.addAction(photoAlbumAction)
        }
        
        //取消
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            
        })
        alertController.addAction(cancelAction)
        
        //顯示UIAlertController
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //info是dictionary,取key[UIImagePickerControllerOriginalImage]
        //取得相片image
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //上傳相片至Firebase步驟(Firebase->storage)
        //1.將相片先轉成NSData(JPEG檔)
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        //2.建立Metadata:圖檔的檔案類型(看firebase的doc)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        //3.建立Reference(存檔的位置)
        let uuid = NSUUID().uuidString //使用uuid作為照片檔名編碼,檔名必須為字串
        let imageName = "photos/\(uuid).jpg"
        let imgRef = FIRStorage.storage().reference().child(imageName)
        
        //觀察上傳進度: put data 會回傳 FIRStorageUploadTask
        let uploadTask = imgRef.put(imageData, metadata: metadata) { (metadata, error) in
            if let error = error{
                print("error:\(error)")
                return
            }else{
                //為每張照片存取細部內容(Firebase->database):authorUID,email,imagePath,imageURL,postDate
                //確定目前有使用者
                if let user = FIRAuth.auth()?.currentUser{
                    let post:[String : Any]  = [
                        "authorUID":user.uid,
                        "email":user.email!,
                        "imagePath":imageName,
                        //firebase 的 write data只接受 NSString,NSNumber,NSDictionary,NSArray 的類型(URL是NSURL的類型)
                        "imageURL":metadata!.downloadURL()!.absoluteString,
                        //*1000轉成毫秒,並且將原本TimeInterval = double 轉成整數 Int
                        "postDate":Int(NSDate().timeIntervalSince1970 * 1000),
                        "postDateReversed": -Int(NSDate().timeIntervalSince1970 * 1000),
                        ]
                    
                    let postRef = self.postsRef.childByAutoId() //在postsRef下再開一個ref(資料夾),存入每張照片的細微內容
                    postRef.updateChildValues(post)
                    
                }
                print("上傳完照片了！DownloadURL:\(metadata!.downloadURL())")
                
                //只要是跟畫面呈現有關的，都要放在 main queue裡，並且一定要是 非同步async
                DispatchQueue.main.async {
                    //呈現出上傳進度: 先轉完loading progress，轉完上傳完成後關掉
                    SVProgressHUD.dismiss()
                    
                    //最後再關掉:(記得要自己關掉)imagePickerController
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
       
        //呈現出上傳進度: FIRStorageUploadTask
        uploadTask.observe(.progress) { (snapshot) in
            let progressPercent = snapshot.progress?.fractionCompleted
            print("\(progressPercent)")
            
            DispatchQueue.main.async{
                //呈現出滾輪再轉的畫面，與畫面有關故使用DispatchQueue.main.async
                SVProgressHUD.showProgress(Float(progressPercent!))
            }
        }
        
        
        
        
        
    }

    
    //登出按鈕
    @IBAction func signOutTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
    }
    
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        return cell
    }
    
    
    
    
    
}
