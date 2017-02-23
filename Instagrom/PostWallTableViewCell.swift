//
//  PostWallTableViewCell.swift
//  Instagrom
//
//  Created by KaKa on 2017/2/21.
//  Copyright © 2017年 KaKa. All rights reserved.
//

import UIKit

class PostWallTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var longPressGestured: UILongPressGestureRecognizer!
    
    
    
    //從storyboard被叫出，很像viewDidLoad()
    override func awakeFromNib() {
        super.awakeFromNib()
        //長按
        longPressGestured = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        photoImageView.addGestureRecognizer(longPressGestured)
        
    }
    
    func longPress(){
        print("press...........")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            print("delete.......")
            
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("cancel.......")
        }
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
