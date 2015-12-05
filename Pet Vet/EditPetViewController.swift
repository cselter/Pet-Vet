//
//  EditPetViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/29/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditPetViewController: UITableViewController, NSFetchedResultsControllerDelegate, BreedPickerListViewControllerDelegate {
     
     // Currently Selected Pet
     var selectedPet: Pet!
     
     @IBOutlet var labels: [UILabel]!
     
     @IBOutlet weak var petNameTextField: UITextField!
     @IBOutlet weak var breedTextField: UITextField!
     @IBOutlet weak var colorTextField: UITextField!
     @IBOutlet weak var birthdateTextField: UITextField!
     @IBOutlet weak var adoptdateTextField: UITextField!
     @IBOutlet weak var microchipTextField: UITextField!
     @IBOutlet weak var registrationIDTextField: UITextField!
     @IBOutlet weak var notesTextView: UITextView!
     @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
     @IBOutlet weak var speciesSegmentedControl: UISegmentedControl!
     
     // Date Formatters & Picker Controls
     let dateFormatter = NSDateFormatter()
     let birthdatepicker: UIDatePicker = UIDatePicker()
     let adoptdatepicker: UIDatePicker = UIDatePicker()
     
     // Temp values to resave with
     var newBirthDate: NSDate?
     var newAdoptDate: NSDate?
     
     override func viewDidLoad() {
          super.viewDidLoad()
          updateWidthsForLabels(labels) // adjust label widths
          tableView.rowHeight = UITableViewAutomaticDimension
          
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
          view.addGestureRecognizer(tap)
          
          petNameTextField.text = selectedPet.name
          breedTextField.text = selectedPet.breed
          colorTextField.text = selectedPet.color
          microchipTextField.text = selectedPet.microchipID ?? ""
          registrationIDTextField.text = selectedPet.registrationID ?? ""
          notesTextView.text = selectedPet.notes ?? ""

          // Load selectedPet Sex option for Segmented Control
          if selectedPet.sex == "Male" {
               sexSegmentedControl.selectedSegmentIndex = 0
          } else {
               sexSegmentedControl.selectedSegmentIndex = 1
          }
          
          // Load selectedPet Species option for Segmented Control
          if selectedPet.species == "Dog" {
               speciesSegmentedControl.selectedSegmentIndex = 0
          } else {
               speciesSegmentedControl.selectedSegmentIndex = 1
          }

          self.setupDateFormatters()
          
          let saveButton = UIBarButtonItem(title: "Save Changes", style: .Done, target: self, action: "saveChanges:")
          
          self.navigationItem.rightBarButtonItem = saveButton
     }
     
     func dateUpdated(sender: UIDatePicker) {
          if sender == birthdatepicker
          {
               birthdateTextField.text = dateFormatter.stringFromDate(sender.date)
               newBirthDate = sender.date
          }
          if sender == adoptdatepicker
          {
               adoptdateTextField.text = dateFormatter.stringFromDate(sender.date)
               newAdoptDate = sender.date
          }
     }
     
     func saveChanges(sender: UIBarButtonItem) {
          if petNameTextField.text == "" || petNameTextField.text == nil {
               showAlert("Name is required.")
          } else {
               selectedPet.name = petNameTextField.text!
          }
          
          if breedTextField.text == "" || breedTextField.text == nil {
               showAlert("Breed is required.")
          } else {
               selectedPet.breed = breedTextField.text!
          }
          
          if colorTextField.text == "" || colorTextField.text == nil {
               showAlert("Color is required.")
          } else {
               selectedPet.color = colorTextField.text!
          }
          
          if birthdateTextField.text == "" || birthdateTextField.text == nil || newBirthDate == nil {
               showAlert("Birthdate is required.")
          } else {
               selectedPet.birthdate = newBirthDate!
          }
          
          if adoptdateTextField.text == "" || adoptdateTextField.text == nil || newAdoptDate == nil {
               // adopt date required
          } else {
               selectedPet.adoptDate = newAdoptDate!
          }
          
          if speciesSegmentedControl.selectedSegmentIndex == 0 {
               selectedPet.species = "Dog"
          } else {
               selectedPet.species = "Cat"
          }
          
          if sexSegmentedControl.selectedSegmentIndex == 0 {
               selectedPet.sex = "Male"
          } else {
               selectedPet.sex = "Female"
          }
          
          selectedPet.microchipID = microchipTextField.text! ?? ""
          selectedPet.registrationID = registrationIDTextField.text! ?? ""
          selectedPet.notes = notesTextView.text! ?? ""
          
          CoreDataStackManager.sharedInstance().saveContext()
          self.navigationController!.popViewControllerAnimated(true)
     }

     
     
     @IBAction func breedButtonPressed(sender: AnyObject) {
          // Check if petfinder.com is accessable
          if Network.isConnectedToNetwork() == false {
               let alert = UIAlertController(title: "Network Connectivity", message: "Cannot access PetFinder.com API.\n\nEnter Breed Name Manually or connect to the Internet.", preferredStyle: UIAlertControllerStyle.Alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
               presentViewController(alert, animated: true, completion: nil)
          } else {
               let breedController = storyboard!.instantiateViewControllerWithIdentifier("BreedPickerListViewController") as! BreedPickerListViewController
               
               breedController.delegate = self
               
               if speciesSegmentedControl.selectedSegmentIndex == 0 {
                    breedController.species = "dog"
                    
               } else {
                    breedController.species = "cat"
               }
               self.presentViewController(breedController, animated: true, completion: nil)
          }
     }
     
     // Breed Picker Delegate
     func breedPicker(breedPicker: BreedPickerListViewController, didPickBreed breed: String?) {
          if let newBreed = breed {
               print("breed selected: \(newBreed)")
               breedTextField.text = newBreed
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

     
     func setupDateFormatters() {
          dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
          
          birthdateTextField.text = dateFormatter.stringFromDate(selectedPet.birthdate)
          adoptdateTextField.text = dateFormatter.stringFromDate(selectedPet.adoptDate)
          
          birthdatepicker.datePickerMode = UIDatePickerMode.Date
          adoptdatepicker.datePickerMode = UIDatePickerMode.Date
          birthdateTextField.inputView = birthdatepicker
          adoptdateTextField.inputView = adoptdatepicker
          
          newBirthDate = selectedPet.birthdate
          newAdoptDate = selectedPet.adoptDate
          
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

}