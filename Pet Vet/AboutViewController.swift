//
//  AboutViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/15/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
     
     
     @IBOutlet weak var petCountLabel: UILabel!
     
     let StoredPetKey = "Stored Pet Count"
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          // Retrieve the current Pet Count value from NSUserDefaults
          let petCount = NSUserDefaults.standardUserDefaults().integerForKey(StoredPetKey)
          
          petCountLabel.text = "\(petCount)"
     }
     
     
     // open email to petvetapp@cottontailsolutions.com
     @IBAction func supportEmailButtonPressed(sender: AnyObject) {
          let sendSupportMailVC = MFMailComposeViewController()
          sendSupportMailVC.mailComposeDelegate = self
          sendSupportMailVC.setSubject("Pet Vet App Support/Feedback")
          sendSupportMailVC.setMessageBody("Please be as detailed as possible:\n", isHTML: false)
          sendSupportMailVC.setToRecipients(["petvetapp@cottontailsolutions.com"])
          presentViewController(sendSupportMailVC, animated: true, completion: nil)
     }
     
     func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
          dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     @IBAction func dismissAboutButton(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
    
     @IBAction func cottontailButtonPressed(sender: AnyObject) {
          
          // open safari to cottontailsolutions.com/app/petvet
     }
     
}