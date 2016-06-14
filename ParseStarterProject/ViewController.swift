/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse


class ViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    // Change the Login screen text if user signed-up
    var signupActive = true // initally user is signing up
    @IBOutlet var loginToSignupButton: UIButton!
    
    @IBOutlet var NewUserText: UILabel!
    
    @IBOutlet var signupToLoginButton: UIButton!
    
  
    
    // Used to freeze the screen when signup information is being verified
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
    
    @IBAction func loginButton(sender: AnyObject) {
        ////
        // *Create Alert pop-up if sign-up fails, else a sign-in the user*
        /////
        // If user didn't enter any sign-up information, then send an alert message
        if username.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        } else {
            // Create a loading spinner of specified size:
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            // Set it at the middle of the screen:
            activityIndicator.center = self.view.center
            // Hide it when finished loading:
            activityIndicator.hidesWhenStopped = true
            // Style:
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            // Make the activity indicator viewable to the user:
            view.addSubview(activityIndicator)
            // Activate the activity indicator:
            activityIndicator.startAnimating()
            // Freeze the entire application:
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            // Sign-in process begin:
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            // Generate error message if actual error cannot be displayed:
            var errorMessage = "Please try again later"
            
            //Login the user:
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user, error) -> Void in
            // We can now stop the activity indicator:
            self.activityIndicator.stopAnimating()
            // Allow the user to start using the app again:
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // Logged in!
                // Segue into the Navigation Controller:
                self.performSegueWithIdentifier("login", sender: self)
                
            } else {
                if let errorString = error!.userInfo["error"] as? String {
                    errorMessage = errorString
                }
                self.displayAlert("Failed login", message: errorMessage)
            }
        }
        }
    }
    
    @IBAction func signupButton(sender: AnyObject) {
        ////
        // *Create Alert pop-up if sign-up fails, else a sign-in the user*
        /////
        // If user didn't enter any sign-up information, then send an alert message
        if username.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        } else {
            // Create a loading spinner of specified size:
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            // Set it at the middle of the screen:
            activityIndicator.center = self.view.center
            // Hide it when finished loading:
            activityIndicator.hidesWhenStopped = true
            // Style:
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            // Make the activity indicator viewable to the user:
            view.addSubview(activityIndicator)
            // Activate the activity indicator:
            activityIndicator.startAnimating()
            // Freeze the entire application:
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            // Sign up process begin:
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            // Generate error message if actual error cannot be displayed:
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                // We can now stop the activity indicator:
                self.activityIndicator.stopAnimating()
                // Allow the user to start using the app again:
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                // Check if sign-up is successful:
                if error == nil {
                    // sign-upsuccessful
                    // Segue into the Navigation Controller:
                    self.performSegueWithIdentifier("login", sender: self)
                    
                } else {
                    if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                    }
                    // Display alert using alert helper function:
                    self.displayAlert("Failed signup", message: errorMessage)
                }
            })
            
        }
        ///////////////////////////////////////////////////////////////////////////////////////
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Check if there is a current user logged in and if so, perform the segue 
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
