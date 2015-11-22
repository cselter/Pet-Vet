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

class AboutViewController: UIViewController {
     
     // Currently Selected Pet
     var selectedPet: Pet!
     
     
     
     
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
         
          
     }
     
     
     
     
     
     @IBAction func dismissAboutButton(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
     }
    
     
}