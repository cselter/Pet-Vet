//
//  ViewPetViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/11/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewPetViewController: UIViewController {
     
     // Currently Selected Pet
     var selectedPet: Pet!
     
     @IBOutlet weak var petNameLabel: UILabel!
     @IBOutlet weak var sexAndBreedLabel: UILabel!
     @IBOutlet weak var ageLabel: UILabel!
     
     
     
     
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          petNameLabel.text = selectedPet.name
          if selectedPet.sex == "Male" {
               petNameLabel.textColor = UIColor.blueColor()
          }
          
          ageLabel.text = selectedPet.calculateAge()
          sexAndBreedLabel.text = ""
          sexAndBreedLabel.text?.appendContentsOf(selectedPet.sex)
          sexAndBreedLabel.text?.appendContentsOf(" \(selectedPet.breed)")
          
     }
          
     
     
     
     
     
     
     
     @IBAction func dismissViewPet(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     
     
     
     
     
     
}

