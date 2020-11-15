//
//  UserCell.swift
//  Test Github
//
//  Created by Rheza Pahlevi on 11/15/20.
//  Copyright © 2020 Rheza Pahlevi. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
