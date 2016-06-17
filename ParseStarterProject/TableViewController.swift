//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel Islam on 2016-06-13.
//  Copyright © 2016 Parse. All rights reserved.
//

// ***********
// This class will controll the table view (the screen after user has logged in)
// ***********
import UIKit
import Parse

class TableViewController: UITableViewController {
    
    // This is the array that stores the usernames that will be displayed in our table.
    var usernames = [""]
    // We will track user followers by using their objectId
    var userids = [""]
    // Track who the current user is following dictionary:
    var isFollowing = ["":false]
    
    // Pull to Refresh variable (forced unwrapped):
    var refresher: UIRefreshControl!
    
    // Refresh function for [Pull to Refresh]
    func refresh() {
        
        // Scan through the online-stored parse data and put the usernames & ids to the global areas above.
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                // Remove current elements in array (including empty)
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                for object in users {
                    if let user = object as? PFUser {
                        // Add all but the current user to the table view:
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            /// /// ///
                            // ** Update the followers of the current user from parse:
                            var query = PFQuery(className: "followers")
                            // We need to make sure two conditions for the checkmarks to be updated:
                            // Search the parse online data to see if the current user [PFUser...] is a [follower] of any [following]
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            // Also make sure that the person that current user is following is the actual tapped user
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            // The loop query will run true if the two function above where successfully satisfied:
                            // Now scan through the current users and check them off:
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                        
                                        self.isFollowing[user.objectId!] = true // These boolean statements will feed the [following] array
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    // Push the new data to the table:
                                    self.tableView.reloadData()
                                    // End the refreshing after table has been updated:
                                    self.refresher.endRefreshing()
                                }
                                
                            })
                            /// /// ///
                        }
                    }
                }
            }
            
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // *** Pull to Refresh *** //
        refresher = UIRefreshControl()
        // String will appear when user begins to pull the table:
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        // Run the refresh function when the screen was pulled (aka .ValueChanged)
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
        /// /// /// /// /// /// /// ///
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Have as many rows as there are users:
        return usernames.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // The text in each row should be the specific user:
        cell.textLabel?.text = usernames[indexPath.row]
        
        let followedObjectId = userids[indexPath.row]
        // We will give check-marks to the users that are in the [following] array:
        if isFollowing[followedObjectId] == true {
             cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }

       ////////    ////////    ////////    ////////
    //*** This runs when a user taps on a cell ****//
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
         let followedObjectId = userids[indexPath.row]
        
        // ** Deselect option ** // 
        if isFollowing[followedObjectId] == false {
            isFollowing[followedObjectId] = true
            // Update table with a check-mark to indicate that current user is following already:
            //  Get the tapped cell and add a check mark:
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            
            var following = PFObject(className: "followers")
            // Add the tapped user-id in the following column:
            following["following"] = userids[indexPath.row]
            // Add the current user as a follower to the table
            following["follower"] = PFUser.currentUser()?.objectId
            // push to the parse server:
            following.saveInBackground()
        } else {
            isFollowing[followedObjectId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            // Same query from the code above:
            
            
            
            // ** Update the followers of the current user from parse:
            var query = PFQuery(className: "followers")
            // We need to make sure two conditions for the checkmarks to be updated:
            // Search the parse online data to see if the current user [PFUser...] is a [follower] of any [following]
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            // Also make sure that the person that current user is following is the actual tapped user
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            // The loop query will run true if the two function above where successfully satisfied:
            // Now scan through the current users and check them off:
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for objects in objects {
                        objects.deleteInBackground()
                    }
                }
            })
            /// /// ///
            
            
            
        }
        
        
        /// /// /// /// ///
        
        
        
        
        
    }
    ////////    ////////    ////////    ////////    ////////
}
