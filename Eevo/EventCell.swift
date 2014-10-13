//
//  EventCell.swift
//  Eevo
//
//  Created by Paul Lo on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    var event: PFObject!
    var showThumbnail = true
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: PFImageView!
    @IBOutlet weak var organizerThumbnailView: PFImageView!
    @IBOutlet weak var attendingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    func updateCellWithEvent(event: PFObject!) {
        self.event = event
        self.eventNameLabel.text = (event["name"] as? String)
        self.backgroundImageView.file = (event["image_large"] as? PFFile)
        self.backgroundImageView.loadInBackground()
        if var organizer = event["organizer"] as? PFObject {
            organizer.fetchIfNeededInBackgroundWithBlock() { (object: PFObject!, error: NSError!) -> Void in
                if var user = object["user"] as? PFObject {
                    user.fetchIfNeededInBackgroundWithBlock({ (userFetched: PFObject!, error: NSError!) -> Void in
                        if self.showThumbnail {
                            self.organizerThumbnailView.file = (userFetched["avatar_thumbnail"] as? PFFile)
                            self.organizerThumbnailView.loadInBackground()
                        }
                    })
                }
            }
        }
        self.attendingCountLabel.text = "22 attending"
        
        var address = (self.event["address"] as? String)
        var city = (self.event["city"] as? String)
        var region = (self.event["region"] as? String)
        if address != nil && city != nil && region != nil {
            self.addressLabel.text = "\(address!), \(city!), \(region!)"
        } else {
            self.addressLabel.text = ""
        }
        
        if var startTime = event["from_date"] as? NSDate {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            var startTimeStr = formatter.stringFromDate(startTime)
            self.eventTimeLabel.text = startTimeStr
        } else {
            self.eventTimeLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
