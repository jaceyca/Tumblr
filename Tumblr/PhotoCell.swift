//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Jessica Choi on 6/16/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

  
    @IBOutlet weak var tumblrImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
