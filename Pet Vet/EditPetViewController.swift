//
//  EditPetViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/11/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class EditPetViewController: UIViewController {
     
     // Currently Selected Pet
     var selectedPet: Pet!
     
     @IBOutlet weak var editPetLabel: UILabel!
     @IBOutlet weak var petNameTextField: UITextField!

     @IBOutlet weak var petImageView: UIImageView!
     
     @IBOutlet weak var sexAndSpeciesLabel: UILabel!
     
     @IBOutlet weak var breedTextField: UITextField!

     @IBOutlet weak var colorTextField: UITextField!
     @IBOutlet weak var birthdateTextField: UITextField!
     @IBOutlet weak var adoptdateTextField: UITextField!
     @IBOutlet weak var microchipTextField: UITextField!
     @IBOutlet weak var registrationIDTextField: UITextField!
     @IBOutlet weak var notesTextView: UITextView!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          editPetLabel.text = "Edit \(selectedPet.name)'s Information"
          petNameTextField.text = selectedPet.name
          
          var speciesText: String = ""
          var sexText: String = ""
          
          if selectedPet.species == "Dog" {
               speciesText = "Dog"
          } else {
               speciesText = "Cat"
          }
          
          if selectedPet.sex == "Male" {
               sexText = "Male"
          } else {
               sexText = "Female"
          }
     
          sexAndSpeciesLabel.text = "\(sexText) \(speciesText)"
          
          breedTextField.text = selectedPet.breed
          colorTextField.text = selectedPet.color
          microchipTextField.text = selectedPet.microchipID ?? ""
          registrationIDTextField.text = selectedPet.registrationID ?? ""
          notesTextView.text = selectedPet.notes ?? ""
          
          
          if selectedPet.sex == "Male" {
               editPetLabel.textColor = UIColor.blueColor()
          }
          
          
          
     }
          
     
     
     
     @IBAction func saveChanges(sender: AnyObject) {
          
          
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     
     
     @IBAction func dismissViewPet(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     
     
     
     
     
     
}

