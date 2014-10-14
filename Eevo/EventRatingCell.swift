//
//  EventRatingCell.swift
//  Eevo
//
//  Created by Paul Lo on 10/13/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventRatingCell: UITableViewCell {

    var rating: PFObject!
    
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCellWithRating(rating: PFObject!) {
        self.rating = rating
        self.rating.fetchIfNeededInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if var avgRating = object["avg_rating"] as? Double {
                var percentRating = Int((avgRating / 5.0) * 100.0)
                self.ratingLabel.text = "Scores: \(percentRating)%"
            }
            else {
                self.ratingLabel.text = "Scores: N/A"
            }
            if var ratingsCount = object["ratings_count"] as? Int {
                self.ratingsCountLabel.text = "Feedbacks: \(ratingsCount)"
            }
            else {
                self.ratingsCountLabel.text = "Feedbacks: 0"
            }
            self.eventCategoryLabel.text = ""
            if var ratingSpec = object["rating_spec"] as? PFObject {
                self.eventCategoryLabel.text = (ratingSpec["rating_name"] as? String)
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
