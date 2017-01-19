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
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
    
        //相簿選取照片
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){ //一開始就先確認是否有photoLibrary的功能可以用,沒有就不顯示按鍵
            let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .default, handler: {(action) in
                self.imagePicker.sourceType = .photoLibrary
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
