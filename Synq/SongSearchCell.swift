//
//  SongSearchCell.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/13/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import UIKit

class SongSearchCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
