//
//  AddEditPetViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/4/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class AddEditPetViewController: UIViewController, NSFetchedResultsControllerDelegate {

     @IBOutlet weak var nameTextField: UITextField!
     @IBOutlet weak var speciesToggle: UISegmentedControl!
     @IBOutlet weak var breedTextField: UITextField!
     @IBOutlet weak var sexToggle: UISegmentedControl!
     @IBOutlet weak var colorTextField: UITextField!
     @IBOutlet weak var microchipTextField: UITextField!
     @IBOutlet weak var registrationIDTextField: UITextField!
     @IBOutlet weak var notesTextView: UITextView!
     @IBOutlet weak var birthdateTextField: UITextField!
     @IBOutlet weak var adoptionDateTextField: UITextField!
     var adoptionDate: NSDate?
     var birthdateDate: NSDate?
     
     let missingName: String = "Name is required."
     let missingColor: String = "Color is required."
     let missingBirthdate: String = "Birthdate is required."
     let missingBreed: String = "Breed is required."
     
     
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
       
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }
     
     
     
     @IBAction func birthdateEditBegin(sender: UITextField) {
          let datePickerView: UIDatePicker = UIDatePicker()
          datePickerView.datePickerMode = UIDatePickerMode.Date
          sender.inputView = datePickerView
          datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
     }
     
     func datePickerValueChanged(sender:UIDatePicker) {
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          birthdateTextField.text = dateFormatter.stringFromDate(sender.date)
          birthdateDate = sender.date
     }
     
     @IBAction func adoptDateEditBegin(sender: UITextField) {
          let datePickerView: UIDatePicker = UIDatePicker()
          datePickerView.datePickerMode = UIDatePickerMode.Date
          sender.inputView = datePickerView
          datePickerView.addTarget(self, action: Selector("adoptDatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
     }
     
     func adoptDatePickerValueChanged(sender:UIDatePicker) {
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          adoptionDateTextField.text = dateFormatter.stringFromDate(sender.date)
          adoptionDate = sender.date
     }


     
     
     
     
     @IBAction func addNewPet(sender: AnyObject) {
          
          if nameTextField.text == nil || nameTextField.text == "" {
               showAlert(missingName)
          } else if birthdateTextField.text == nil || birthdateTextField.text == "" {
               showAlert(missingBirthdate)
          } else if colorTextField.text == nil || colorTextField.text == "" {
               showAlert(missingColor)
          } else if breedTextField.text == nil || breedTextField.text == "" {
               showAlert(missingBreed)
          } else {

               var speciesString: String! = ""
               var sexString: String! = ""
               
               if speciesToggle.selectedSegmentIndex == 0 {
                    speciesString = "Dog"
                    
               } else {
                    speciesString = "Cat"
               }
               
               if sexToggle.selectedSegmentIndex == 0 {
                    sexString = "Male"
               } else {
                    sexString = "Female"
               }
               
               if adoptionDateTextField.text == "" || adoptionDateTextField.text == nil {
                    adoptionDate = birthdateDate
               }
               
               var newPet : [String:AnyObject] = [
                    "name" : nameTextField.text as String!,
                    "species" : speciesString as String!,
                    "sex" : sexString as String!,
                    "color" : colorTextField.text as String!,
                    "breed" : breedTextField.text as String!,
                    "microchipID" : microchipTextField.text as String!,
                    "registrationID" : registrationIDTextField.text as String!,
                    "notes" : notesTextView.text as String!,
                    "birthdate" : birthdateDate as NSDate!,
                    "adoptDate" : adoptionDate as NSDate!
               ]
               
               
               
               let addPet = Pet(dictionary: newPet, context: self.sharedContext)
               
               CoreDataStackManager.sharedInstance().saveContext()
               
               self.dismissViewControllerAnimated(true, completion: nil)
          }
     }
     
     
     
     
     // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
     var sharedContext: NSManagedObjectContext {
          return CoreDataStackManager.sharedInstance().managedObjectContext!
     }
     
     
     func showAlert (alertString: String) {
          var alert = UIAlertController(title: "Missing Information", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
          
          
          self.presentViewController(alert, animated: true, completion: nil)
          
     }
     
     
     @IBAction func cancelAndDismiss(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
       
}

