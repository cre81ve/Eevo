//
//  OrganizerCell.swift
//  Eevo
//
//  Created by Paul Lo on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizerCell: UITableViewCell {

    var organizer: PFObject!
    
    @IBOutlet weak var organizersCountLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailView: PFImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var organizerSummaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
