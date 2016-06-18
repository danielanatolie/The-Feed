//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel Islam on 2016-06-17.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        // Present the image view controller to the user:
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    // This function will run when the user has picked the image:
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            // Dismiss the image view controller once the image has been chosen by the user
            self.dismissViewControllerAnimated(true, completion: nil)
        
            imageToPost.image = image // Set the image to user's choice. 
    }
    
    @IBOutlet var message: UITextField!
    
    // Upload image to Parse:
    @IBAction func postImage(sender: AnyObject) {
        // Save the message, userId, and imageFile to parse
        var post = PFObject(className: "Post")
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()?.objectId!
        
        // Convert the chosen image to data, and save the image to parse:
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        post["imageFile"] = imageFile
        
        // Save the data:
        post.saveInBackgroundWithBlock { (sucess, error) -> Void in
            if error == nil {
                print("Success")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
