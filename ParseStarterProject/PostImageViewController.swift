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

    // Used to freeze the screen when signup information is being verified
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    // *Helper Function to display alert pop-up*:
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // give user an action to take during alert screen:
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // Dismiss alert if action is "OK" button is pressed:
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        // Displays the actual alert:
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // * Image Compresser to fulfill 10mb Requirement: * //
    func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
        
        let originalSize = original.size
        var newSize = originalSize
        
        if originalSize.width > widthLimit && originalSize.width > originalSize.height {
            
            newSize.width = widthLimit
            newSize.height = originalSize.height*(widthLimit/originalSize.width)
        }else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
            
            newSize.height = heightLimit
            newSize.width = originalSize.width*(heightLimit/originalSize.height)
        }
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return compressedImage
    }
    /// /// /// /// /// /// /// ************ /// /// /// /// /// /// ///
    
    @IBOutlet var message: UITextField!
    
    // Upload image to Parse:
    @IBAction func postImage(sender: AnyObject) {
        // Activity indicator and freeze application until data upload is finished:
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha:0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Block user from using app:
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // Save the message, userId, and imageFile to parse
        var post = PFObject(className: "Post")
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()?.objectId!
        
        // Convert and compress the chosen image to data (to full 10mb parse restrictions) and save the image to parse:
//        let imageData = UIImagePNGRepresentation(imageToPost.image!)
//        let imageFile = PFFile(name: "image.png", data: imageData!)
        // Compress image:
        let compressedImage = compressForUpload(imageToPost.image!, withHeightLimit: 1000, andWidthLimit: 1000)
        let compressedImageData = UIImagePNGRepresentation(compressedImage)
        let imageFile = PFFile(name:"image.png", data: compressedImageData!)
        post["imageFile"] = imageFile
        
        // Save the data:
        post.saveInBackgroundWithBlock { (sucess, error) -> Void in
            
            // Unfreeze application and remove activity indicator:
            self.activityIndicator.stopAnimating()
            
            // Block user from using app:
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                // Display success alert:
                self.displayAlert("Image Posted", message: "The Feed has your image!")
                
                // Reset to default place-holder image:
                self.imageToPost.image = UIImage(named: "placeholder.png")
                self.message.text = ""
            } else {
                self.displayAlert("Could not post image", message: "Please try again later")
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
