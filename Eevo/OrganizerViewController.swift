//
//  OrganizerViewController.swift
//  Eevo
//
//  Created by Paul Lo on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizerViewController: LoggedInViewController, UITableViewDataSource, UITableViewDelegate  {
    enum OrganizerSection: Int {
        case UpcomingEvents = 0
        case PastEvents = 1
    }

    var organizer: PFObject!
    var upcomingEvents: [PFObject] = []
    var pastEvents: [PFObject] = []
    var refreshControl: UIRefreshControl? = UIRefreshControl()
    
    @IBOutlet weak var headerBackgroundImageView: PFImageView!
    @IBOutlet weak var headerThumbnailView: PFImageView!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var organizerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.organizerTableView.delegate = self
        self.organizerTableView.dataSource = self
        self.organizerTableView.rowHeight = 175.0

        self.refreshControl?.addTarget(self, action: "loadDataFromSource", forControlEvents: .ValueChanged)
        self.organizerTableView.addSubview(self.refreshControl!)
        
        loadDataFromSource()
    }

    func loadDataFromSource() {
        organizer.fetchIfNeededInBackgroundWithBlock() { (object: PFObject!, error: NSError!) -> Void in
            self.headerBackgroundImageView.file = (object["background_image"] as? PFFile)
            self.headerBackgroundImageView.loadInBackground()
            if var user = object["user"] as? PFObject {
                user.fetchIfNeededInBackgroundWithBlock({ (userFetched: PFObject!, error: NSError!) -> Void in
                    self.headerThumbnailView.file = (userFetched["avatar_thumbnail"] as? PFFile)
                    self.headerThumbnailView.loadInBackground()
                })
            }
        }
        
        var query = PFQuery(className: "Event")
        query.whereKey("organizer", equalTo: self.organizer)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (events: [AnyObject]!, error: NSError!) -> Void in
            self.pastEvents = []
            self.upcomingEvents = []
            if events != nil {
                var currentTime = NSDate()
                for event in events {
                    if var fromDate = event["from_date"] as? NSDate {
                        if fromDate.compare(currentTime) == NSComparisonResult.OrderedAscending {
                            self.pastEvents.append(event as PFObject)
                        } else {
                            self.upcomingEvents.append(event as PFObject)
                        }
                        
                    }
                }
            }
            self.organizerTableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if upcomingEvents.isEmpty && pastEvents.isEmpty {
            return 0
        }
        return pastEvents.isEmpty ? 1 : 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        switch OrganizerSection.fromRaw(section)! {
            case .UpcomingEvents: title = "Upcoming Events"
            case .PastEvents: title = "Past Events"
        }
        return title
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch OrganizerSection.fromRaw(section)! {
            case .UpcomingEvents: count = self.upcomingEvents.count
            case .PastEvents: count = self.pastEvents.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventCell?
        if cell == nil {
            var nib = UINib(nibName: "EventCell", bundle: nil)
            var objects = nib.instantiateWithOwner(self, options: nil)
            cell = objects[0] as? EventCell
        }
        var event: PFObject? = nil
        switch OrganizerSection.fromRaw(indexPath.section)! {
            case .UpcomingEvents: cell?.updateCellWithEvent(self.upcomingEvents[indexPath.row])
            case .PastEvents: cell?.updateCellWithEvent(self.pastEvents[indexPath.row])
        }
        return cell ?? UITableViewCell()
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
