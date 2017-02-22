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

class PostWallTableViewController: UITableViewController {
    
    //Data
    //1-1.建立資料庫的reference (像資料庫的table,或是說資料夾)
    var ref: FIRDatabaseReference! //會開在最上層
    var postsRef: FIRDatabaseReference!
    
    /* Firebase提供的FirebaseDatabaseUI:Firebase針對不同平台發布的簡易UI元件
    將UITableView的datasource換成這個FUITableViewDataSource*/
    var dataSource: FUITableViewDataSource!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //動態調整row height高度,依據cell內的東西大小去長
        tableView.rowHeight = UITableViewAutomaticDimension
        //估測tableView總高度
        tableView.estimatedRowHeight = 369
        
        ref = FIRDatabase.database().reference()
        postsRef = ref.child("posts")//在ref下開一層新資料夾"posts"
        //FUITableViewDataSource
        dataSource = tableView.bind(to: postsRef, populateCell: { (tableView, indexPath, snapshot) in
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
        
        
        
        
        
//        //讀取資料
//        //observeSingleEvent 只讀一次
//        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            print("\(snapshot.value)")
//        })
        
        
        
        

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
