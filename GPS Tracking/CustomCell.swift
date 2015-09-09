//
//  CustomCell.swift
//  Install
//
//  Created by Nguyen Bui on 1/10/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var deviceName: UILabel!
    @IBOutlet var serialNumber: UILabel!
    @IBOutlet var deleteButton: UIButton!

    /*
    Comment this out since we are no using xib
    gist.github.com/imalberto/dec285b2b00241c847a9
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    */
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
