//
//  PetIDViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/28/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit

class PetIDViewController: UIViewController, UITextViewDelegate {

     @IBOutlet weak var missingText: UITextField!
     @IBOutlet weak var petPhotoImageView: UIImageView!
     @IBOutlet weak var missingLabelSwitch: UISwitch!
     @IBOutlet weak var petnameLabel: UILabel!
     @IBOutlet weak var petIDTitleTextField: UITextField!
     @IBOutlet weak var sexLabel: UILabel!
     @IBOutlet weak var breedLabel: UILabel!
     @IBOutlet weak var colorLabel: UILabel!
     @IBOutlet weak var ageLabel: UILabel!
     @IBOutlet weak var microchipLabel: UILabel!
     @IBOutlet weak var actionButton: UIBarButtonItem!
     @IBOutlet weak var bottomToolbar: UIToolbar!
     @IBOutlet weak var missingPosterTextLabel: UILabel!
     @IBOutlet weak var missingInfoTextView: UITextView!
     
     var selectedPet: Pet!
     
     let missingTextAttributes = [
          NSStrokeColorAttributeName : UIColor.blackColor(),
          NSForegroundColorAttributeName : UIColor.redColor(),
          NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
          NSStrokeWidthAttributeName : -3.0
     ]
     
     let petIDTextAttributes = [
          NSStrokeColorAttributeName : UIColor.blackColor(),
          NSForegroundColorAttributeName : UIColor.whiteColor(),
          NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
          NSStrokeWidthAttributeName : -3.0
     ]
     
    override func viewDidLoad() {
          super.viewDidLoad()

          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
          view.addGestureRecognizer(tap)
     
          if selectedPet.photo != nil {
               petPhotoImageView.image = UIImage(data: selectedPet.photo!)
          } else {
               petPhotoImageView.image = UIImage(named: "cameraBlue")
          }

          petnameLabel.text = selectedPet.name
     
          missingText.text?.appendContentsOf(" \(selectedPet.species.uppercaseString)")
          missingText.defaultTextAttributes = missingTextAttributes
          missingText.textAlignment = NSTextAlignment.Center
     
          petIDTitleTextField.defaultTextAttributes = petIDTextAttributes
          petIDTitleTextField.textAlignment = NSTextAlignment.Center
     
          if !missingLabelSwitch.on {
               missingText.hidden = true
               missingInfoTextView.hidden = true
          }
     
          missingLabelSwitch.addTarget(self, action: Selector("missingSwitchChanged:"), forControlEvents: UIControlEvents.ValueChanged)
     
          sexLabel.text = "Sex: \(selectedPet.sex)"
          breedLabel.text = "Breed: \(selectedPet.breed)"
          ageLabel.text = "Age: \(selectedPet.calculateAge())"
          colorLabel.text = "Color: \(selectedPet.color)"
     
          if selectedPet.microchipID != "" {
               microchipLabel.text = "Microchip ID: \(selectedPet.microchipID)"
          } else {
               microchipLabel.text = ""
          }
     }
     
     
     override func viewWillAppear(animated: Bool) {
          super.viewWillAppear(animated)
          self.subscribeToKeyboardNotifications()
     }
     
     override func viewWillDisappear(animated: Bool) {
          self.unsubscribeFromKeyboardNotifications()
     }

     func missingSwitchChanged(missingLabelSwitch: UISwitch) {
          if missingLabelSwitch.on {
               missingText.hidden = false
               petIDTitleTextField.hidden = true
               missingInfoTextView.hidden = false
          } else {
               missingText.hidden = true
               petIDTitleTextField.hidden = false
               missingInfoTextView.hidden = true
          }
     }
     
     @IBAction func missingPosterButton(sender: AnyObject) {
          let completedPoster = generatePosterImage()
          let activityVC = UIActivityViewController(activityItems: [completedPoster], applicationActivities: nil)
          
          self.presentViewController(activityVC, animated: true, completion: nil)
     }
     
     // create the poster
     func generatePosterImage() -> UIImage {
          // Hide toolbar and navbar
          self.navigationController?.navigationBarHidden = true
          bottomToolbar.alpha = 0
          missingPosterTextLabel.alpha = 0
          
          // Render view to an image
          UIGraphicsBeginImageContextWithOptions(self.view.frame.size, view.opaque, 0.0)
          self.view.drawViewHierarchyInRect(self.view.frame,
               afterScreenUpdates: true)
          let posterImage : UIImage =
          UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          // Show toolbar and navbar
          self.navigationController?.navigationBarHidden = false
          bottomToolbar.alpha = 1
          missingPosterTextLabel.alpha = 1
          
          return posterImage
     }

     // keyboard notifications, show/hide
     func subscribeToKeyboardNotifications() {
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
     }
     
     func unsubscribeFromKeyboardNotifications() {
          NSNotificationCenter.defaultCenter().removeObserver(self, name:
               UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().removeObserver(self, name:
               UIKeyboardWillHideNotification, object: nil)
     }
     
     func keyboardWillShow(notification: NSNotification) {
          if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
               self.view.frame.origin.y -= keyboardSize.height
          }
     }
     
     func getKeyboardHeight(notification: NSNotification) -> CGFloat {
          let userInfo = notification.userInfo
          let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
          return keyboardSize.CGRectValue().height
     }
     
     func keyboardWillHide(notification: NSNotification) {
          if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
               self.view.frame.origin.y += keyboardSize.height
          }
     }

     func dismissKeyboard() {
          view.endEditing(true)
     }
     
}
