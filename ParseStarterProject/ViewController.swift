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
    
    @IBAction func loginButton(sender: AnyObject) {
        ////////////////////////////////////////////////////////////////////////////////////////
        // Create Alert pop-up if sign-in fails
        ///////////////////////////////////////////////////////////////////////////////////////
        // If user didn't enter any sign-up information, then send an alert message
        if username.text == "" || password.text == "" {
            var alert = UIAlertController(title: "Error in form", message: "Please enter a username and password", preferredStyle: UIAlertControllerStyle.Alert)
            // give user an action to take during alert screen:
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                // Dismiss alert if action is "OK" button is pressed:
                self.dismissViewControllerAnimated(true, completion: nil)
            })))
            // Displays the actual alert:
            self.presentViewController(alert, animated: true, completion: nil)
        }
        ///////////////////////////////////////////////////////////////////////////////////////
    }
    
    @IBAction func signupButton(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
