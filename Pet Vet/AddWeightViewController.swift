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
     @IBOutlet weak var datePicker: UIDatePicker!
     
     var weightAmt: Double = 0.0
     var weightDate: NSDate!
     
     let missingWeight: String = "Weight is required."
     let missingDate: String = "Date is required."
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          // Preset date to today
          weightDate = NSDate()
          
     }

     @IBAction func weightDateEditBegin(sender: UITextField) {
          let datePickerView: UIDatePicker = UIDatePicker()
          datePickerView.datePickerMode = UIDatePickerMode.Date
          sender.inputView = datePickerView
          datePickerView.addTarget(self, action: Selector("weightDatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
     }
     
     func weightDatePickerValueChanged(sender:UIDatePicker) {
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          dateTextField.text = dateFormatter.stringFromDate(sender.date)
          weightDate = sender.date
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
     
     @IBAction func cancelButtonPressed(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
}