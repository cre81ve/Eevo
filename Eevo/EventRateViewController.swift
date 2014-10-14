//
//  EventRateViewController.swift
//  Eevo
//
//  Created by Paul Lo on 10/14/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventRateViewController: LoggedInViewController, UITableViewDataSource, UITableViewDelegate {

    var event: PFObject!
    var ratings: [String: PFObject] = [:]
    var ratingSpecs: [PFObject] = []
    
    @IBOutlet weak var rateEventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rateEventTableView.delegate = self
        self.rateEventTableView.dataSource = self
        self.rateEventTableView.rowHeight = 51.0
        loadFromDataSource()
    }
    
    func loadFromDataSource() {
        event.fetchIfNeededInBackgroundWithBlock { (eventFetched: PFObject!, error: NSError!) -> Void in
            if eventFetched != nil {
                self.ratingSpecs = []
                var query = PFQuery(className: "RatingSpec")
                query.whereKey("event_category", equalTo: eventFetched["main_category"])
                query.addAscendingOrder("display_order")
                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    if objects == nil { return }
                    for object in objects {
                        self.ratingSpecs.append(object as PFObject)
                    }
                    self.rateEventTableView.reloadData()
                })
                
                self.ratings = [:]
                query = PFQuery(className: "Rating")
                query.whereKey("rating_user", equalTo: PFUser.currentUser())
                query.whereKey("event", equalTo: eventFetched)
                query.includeKey("rating_spec")
                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    for object in objects {
                        var rating = object as PFObject
                        var ratingSpec = rating["rating_spec"] as PFObject!
                        if ratingSpec != nil {
                            self.ratings[ratingSpec.objectId] = rating
                        }
                    }
                    self.rateEventTableView.reloadData()
                })
            }
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 51.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingSpecs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RatingInputCell") as RatingInputCell
        var ratingSpec = self.ratingSpecs[indexPath.row]
        var rating: PFObject! = self.ratings[ratingSpec.objectId]
        if rating == nil {
            rating = PFObject(className: "Rating")
            rating["rating_user"] = PFUser.currentUser()
            rating["event"] = self.event
            rating["rating_spec"] = ratingSpec
        }
        cell.eventRateViewController = self
        cell.updateCellWithRating(rating)
        cell.selectionStyle = .None
        return cell
    }
    
    @IBAction func onFormSubmit(sender: AnyObject) {
        for (ratingSpecId, rating) in self.ratings {
            rating.saveInBackground()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
