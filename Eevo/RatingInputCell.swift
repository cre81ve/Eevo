//
//  RatingInputCell.swift
//  Eevo
//
//  Created by Paul Lo on 10/14/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class RatingInputCell: UITableViewCell {

    var rating: PFObject!
    var eventRateViewController: EventRateViewController!
    
    @IBOutlet weak var ratingSpecNameLabel: UILabel!
    @IBOutlet weak var ratingTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        var ratingValue: Int? = ratingTextField.text.toInt()
        if ratingValue != nil {
            if ratingValue < 1 || ratingValue > 5 {
                ratingValue = 1
            } else if ratingValue > 5 {
                ratingValue = 5
            }
        } else {
            ratingValue = 0
        }

        var ratingSpec = self.rating["rating_spec"] as PFObject!
        if ratingValue != nil {
            self.rating["numeric_value"] = ratingValue
            eventRateViewController.ratings[ratingSpec.objectId] = self.rating
        } else {
            eventRateViewController.ratings[ratingSpec.objectId] = nil
        }
    }
    
    func updateCellWithRating(rating: PFObject!) {
        self.rating = rating
        var ratingSpec = rating["rating_spec"] as? PFObject
        self.ratingSpecNameLabel.text = ratingSpec != nil ? (ratingSpec!["rating_name"] as? String) : ""
        var rating_value = rating["numeric_value"] as? Int
        self.ratingTextField.text = rating_value != nil && rating_value > 0 ? "\(rating_value!)" : ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
