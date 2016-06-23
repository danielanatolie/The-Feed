//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel Islam on 2016-06-22.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    // Store all followed users:
    var users = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scan through the online-stored parse data and put the usernames & ids to the global areas above.
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                // Remove current elements in array (including empty)
                self.messages.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                
                for object in users {
                    if let user = object as? PFUser {
                        // populate the global user-area
                        self.users[user.objectId!] = user.username!
                    }
                }
            }
        
        // For every object that has the current follower (Parse/followers/Col:follower="currentID"
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    var followedUser = object["following"] as! String // The user that is being followed, is the one that we are following
                    var query = PFQuery(className: "Post") // Find all of the posts that have been posted by the followed user
                    query.whereKey("userId", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if let objects = objects {
                            for object in objects {
                                // Get data from messages global array:
                                self.messages.append(object["message"] as! String)
                                self.imageFiles.append(object["imageFile"] as! PFFile)
                                self.usernames.append(self.users[object["userId"] as! String]!)
                                // Reload the table data:
                                self.tableView.reloadData()
                            }
                            
                            print(self.users)
                            print(self.messages)
                            
                        }
                    })
                }
            }
        })
        })
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
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell

        // Download appropriate images from Parse:
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            // If data exists within data, then run the if-loop
            if let downloadedImage = UIImage(data: data!) {
                myCell.postedImage.image = downloadedImage
            }
        }
        
        myCell.postedImage.image = UIImage(named: "placeHolder.png")
        
        myCell.username.text = usernames[indexPath.row]
        
        myCell.message.text = messages[indexPath.row]

        return myCell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
