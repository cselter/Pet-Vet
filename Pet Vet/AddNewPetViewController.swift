//
//  AddNewPetViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/28/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddNewPetViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate, BreedPickerListViewControllerDelegate {

     @IBOutlet var labels: [UILabel]!
     
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
     let dateFormatter = NSDateFormatter()
     let birthdatepicker: UIDatePicker = UIDatePicker()
     let adoptdatepicker: UIDatePicker = UIDatePicker()
     
     // Error Messages
     let missingName: String = "Name is required."
     let missingColor: String = "Color is required."
     let missingBirthdate: String = "Birthdate is required."
     let missingBreed: String = "Breed is required."
     let adoptDateBeforeBirthday: String = "Adoption date cannot be before birthdate."
     
     override func viewDidLoad() {
        super.viewDidLoad()
          updateWidthsForLabels(labels) // adjust label widths
          tableView.rowHeight = UITableViewAutomaticDimension
          
          notesTextView.text = ""
          
          nameTextField.delegate = self
          breedTextField.delegate = self
          colorTextField.delegate = self
          microchipTextField.delegate = self
          registrationIDTextField.delegate = self
          
          
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
          view.addGestureRecognizer(tap)
          
          self.setupDateFormatters()
          
          let saveButton = UIBarButtonItem(title: "Save Pet", style: .Done, target: self, action: "addNewPet:")
          
          self.navigationItem.rightBarButtonItem = saveButton
     }

     func dateUpdated(sender: UIDatePicker) {
          if sender == birthdatepicker
          {
               birthdateTextField.text = dateFormatter.stringFromDate(sender.date)
               birthdateDate = sender.date
          }
          if sender == adoptdatepicker
          {
               adoptionDateTextField.text = dateFormatter.stringFromDate(sender.date)
               adoptionDate = sender.date
          }
     }

     // ***********************************************
     // * addNewPet: adds new Pet object to Core Data *
     // ***********************************************
     func addNewPet(sender: UIBarButtonItem) {
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
               
               // Use birthdate as Adoption Date if none entered
               if adoptionDateTextField.text == "" || adoptionDateTextField.text == nil {
                    adoptionDate = birthdateDate
               }
               
               // Load Dictionary with new Pet data
               let newPet : [String:AnyObject] = [
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
               
               // Add the new Pet to Core Data
               let addPet = Pet(dictionary: newPet, context: self.sharedContext)
               CoreDataStackManager.sharedInstance().saveContext()
               
               self.navigationController!.popViewControllerAnimated(true)
          }
     }
     
     @IBAction func breedButtonPressed(sender: AnyObject) {
          // Check if petfinder.com is accessable
          if Network.isConnectedToNetwork() == false {
               let alert = UIAlertController(title: "Network Connectivity", message: "Cannot access PetFinder.com API.\n\nEnter Breed Name Manually or connect to the Internet and retry.", preferredStyle: UIAlertControllerStyle.Alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
               presentViewController(alert, animated: true, completion: nil)
          } else {
               let breedController = storyboard!.instantiateViewControllerWithIdentifier("BreedPickerListViewController") as! BreedPickerListViewController
               
               breedController.delegate = self
               
               if speciesToggle.selectedSegmentIndex == 0 {
                    breedController.species = "dog"
               } else {
                    breedController.species = "cat"
               }
               self.presentViewController(breedController, animated: true, completion: nil)
          }
     }
     
     func dismissKeyboard() {
          view.endEditing(true)
     }

     func showAlert (alertString: String) {
          let alert = UIAlertController(title: "Missing Information", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
     }
     
     // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
     var sharedContext: NSManagedObjectContext {
          return CoreDataStackManager.sharedInstance().managedObjectContext!
     }
     
     // Breed Picker Delegate
     func breedPicker(breedPicker: BreedPickerListViewController, didPickBreed breed: String?) {
          if let newBreed = breed {
               print("breed selected: \(newBreed)")
               breedTextField.text = newBreed
          }
     }
     
     // Set up the birthdate and adopt date formatters and textfields
     func setupDateFormatters() {
          dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          
          birthdatepicker.datePickerMode = UIDatePickerMode.Date
          adoptdatepicker.datePickerMode = UIDatePickerMode.Date
          birthdateTextField.inputView = birthdatepicker
          adoptionDateTextField.inputView = adoptdatepicker
          
          birthdatepicker.addTarget(self, action: Selector("dateUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
          adoptdatepicker.addTarget(self, action: Selector("dateUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
     }
     
     // Helper functions to create equal width labels
     private func calculateLabelWidth(label: UILabel) -> CGFloat {
          let labelSize = label.sizeThatFits(CGSize(width: CGFloat.max, height: label.frame.height))
          return labelSize.width
     }
     
     private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
          let l = labels.map(calculateLabelWidth)
          let r = l.reduce(0, combine: max)
          return r
     }
     
     private func updateWidthsForLabels(labels: [UILabel]) {
          let maxLabelWidth = calculateMaxLabelWidth(labels)
          for label in labels {
               let constraint = NSLayoutConstraint(item: label,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1,
                    constant: maxLabelWidth)
               label.addConstraint(constraint)
          }
     }
     
     func textFieldShouldReturn(textField: UITextField) -> Bool {
          if textField == nameTextField{
               nameTextField.resignFirstResponder()
          }
          if textField == breedTextField{
               breedTextField.resignFirstResponder()
          }
          if textField == colorTextField{
               colorTextField.resignFirstResponder()
          }
          if textField == microchipTextField{
               microchipTextField.resignFirstResponder()
          }
          if textField == registrationIDTextField{
               registrationIDTextField.resignFirstResponder()
          }
          return true
     }
     
     
     
}
