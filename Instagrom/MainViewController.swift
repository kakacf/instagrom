//
//  MainViewController.swift
//  Instagrom
//
//  Created by KaKa on 2017/1/16.
//  Copyright © 2017年 KaKa. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Data
    //1-1.建立資料庫的reference (像資料庫的table,或是說資料夾)
    var ref: FIRDatabaseReference! //會開在最上層
    var messagesRef: FIRDatabaseReference!
    var usersRef: FIRDatabaseReference!
    var chatroomRef: FIRDatabaseReference!
    
    //UI
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var photoImageView: UIImageView!
    
    //新增資料
    @IBAction func addDataTapped(_ sender: Any) {
        /*建立一個新的ref(是一個新的id)在 "messagesRef = ref.child("messages")" 之下
          childByAutoId():產生一個新增資料的ID,*/
        let messagesChild = messagesRef.childByAutoId()
        messagesChild.updateChildValues(["Hello" : "Tom",
                               "Hi":"John"])
    }
    
    
    //讀取資料
    //observeSingleEvent 只讀一次
    @IBAction func readDataTapped(_ sender: Any) {
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            print("\(snapshot.value)")
        })
    }
    
    
    @IBAction func pickPhotoTapped(_ sender: Any) {
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
        
        //上傳相片至Firebase步驟
        //1.將相片先轉成NSData(JPEG檔)
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        //2.建立Metadata:圖檔的檔案類型(看firebase的doc)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        //3.建立Reference(存檔的位置)
        let imgRef = FIRStorage.storage().reference().child("photo.jpg")
        
        imgRef.put(imageData, metadata: metadata) { (metadata, error) in
            if let error = error{
                print("error:\(error)")
                return
            }else{
                print("上傳完照片了！DownloadURL:\(metadata!.downloadURL())")
            }
            
        }
        
        photoImageView.image = image //把相片image顯示在photoImageView裡
        dismiss(animated: true, completion: nil) //記得要自己關掉imagePickerController
        
    }
    //拍照的cancel按鈕可以做事
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        <#code#>
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1-2.建立資料庫的reference
        ref = FIRDatabase.database().reference()
        messagesRef = ref.child("messages")//在ref下開一層新資料夾"messages"
        
        imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
