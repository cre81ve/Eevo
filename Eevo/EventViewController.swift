//
//  EventDetailsViewController.swift
//  Eevo
//
//  Created by Paul Lo on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventViewController: LoggedInViewController, UITableViewDataSource, UITableViewDelegate {

    var event: PFObject!
    var organizer: PFObject!
    var isFromOrganizerViewController = false
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: PFImageView!
    @IBOutlet weak var organizerThumbnailView: PFImageView!
    @IBOutlet weak var attendingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var joinOrRateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.rowHeight = 175.0
        loadFromDataSource()
    }
    
    func loadFromDataSource() {
        self.eventNameLabel.text = (event["name"] as? String)
        self.backgroundImageView.file = (event["image_large"] as? PFFile)
        self.backgroundImageView.loadInBackground()
        self.eventDescriptionLabel.text = (event["description"] as? String)
        self.eventDescriptionLabel.sizeToFit()
        if var organizer = event["organizer"] as? PFObject {
            organizer.fetchIfNeededInBackgroundWithBlock() { (object: PFObject!, error: NSError!) -> Void in
                self.organizer = object
                if var user = object["user"] as? PFObject {
                    user.fetchIfNeededInBackgroundWithBlock({ (userFetched: PFObject!, error: NSError!) -> Void in
                        self.organizerThumbnailView.file = (userFetched["avatar_thumbnail"] as? PFFile)
                        self.organizerThumbnailView.loadInBackground()
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


    @IBAction func onOrganizerThumbnailTap(sender: AnyObject) {
        if self.isFromOrganizerViewController {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            if self.organizer != nil {
                var storyboard = UIStoryboard(name: "Organizer", bundle: nil)
                var organizerController = storyboard.instantiateViewControllerWithIdentifier("OrganizerViewController") as OrganizerViewController
                organizerController.organizer = self.organizer
                self.navigationController?.pushViewController(organizerController, animated: true)
            }
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Event Ratings"
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventRatingCell") as EventRatingCell?
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
