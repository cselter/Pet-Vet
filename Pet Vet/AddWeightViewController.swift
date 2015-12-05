//
//  AddWeightViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/15/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddWeightViewController: UIViewController, NSFetchedResultsControllerDelegate {
     
     var selectedPet: Pet?
     
     @IBOutlet weak var weightTextField: UITextField!
     @IBOutlet weak var dateTextField: UITextField!
     @IBOutlet weak var weightUnitLabel: UILabel!
     var datePicker: UIDatePicker = UIDatePicker()
     
     var weightAmt: Double = 0.0
     var weightDate: NSDate!
     
     let dateFormatter = NSDateFormatter()
     
     let missingWeight: String = "Weight is required."
     let missingDate: String = "Date is required."
     let WeightSettingKey = "Weight Setting"
     override func viewDidLoad() {
          super.viewDidLoad()
          self.navigationItem.title = "Add New Weight"
          
          // Preset date to today
          weightDate = NSDate()
          
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
          view.addGestureRecognizer(tap)
          
          dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          datePicker.datePickerMode = UIDatePickerMode.Date
          dateTextField.inputView = datePicker
          
          datePicker.addTarget(self, action: Selector("dateUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
          
          // Retrieve the preferred weight unit
          if NSUserDefaults.standardUserDefaults().integerForKey(WeightSettingKey) == 0 {
               weightUnitLabel.text = "lbs"
          } else {
               weightUnitLabel.text = "kg"
          }
          
     }
     @IBOutlet weak var dateBorderView: UIView!
     
     func dateUpdated(sender: UIDatePicker) {
          if sender == datePicker
          {
               dateTextField.text = dateFormatter.stringFromDate(sender.date)
               weightDate = sender.date
          }
     }

     @IBAction func saveButtonPressed(sender: AnyObject) {
          if weightTextField.text == nil || weightTextField.text == "" {
               showAlert(missingWeight)
          } else if dateTextField.text == nil || dateTextField.text == "" {
               showAlert(missingDate)
          } else {
               
               let weightDoubleValue : Double = NSString(string: weightTextField.text!).doubleValue
               weightAmt = weightDoubleValue
               
               dispatch_async(dispatch_get_main_queue(), {
                    let addWeight = Weight(weight: self.weightAmt, date: self.weightDate, context: self.sharedContext)
                    addWeight.pet = self.selectedPet
                    CoreDataStackManager.sharedInstance().saveContext()
               
                    self.navigationController!.popViewControllerAnimated(true)
               })
          }
     }
     
     // *************************
     // * Core Data Convenience *
     // *************************
     var sharedContext: NSManagedObjectContext {
          return CoreDataStackManager.sharedInstance().managedObjectContext!
     }
     
     func showAlert (alertString: String) {
          let alert = UIAlertController(title: "Missing Information", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
     }
     
     func dismissKeyboard() {
          view.endEditing(true)
     }
     
     @IBAction func cancelButtonPressed(sender: AnyObject) {
          self.navigationController!.popViewControllerAnimated(true)
     }
}