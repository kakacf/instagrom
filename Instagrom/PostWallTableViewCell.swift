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
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
